Spree::Image.class_eval do
  before_validation :download_remote_image, :if => :label_image_url_provided?
  
  attr_accessible :label_image_remote_url 
  
  has_attached_file(
    :attachment,
    :processors => Proc.new { |a| a.processors },
    :styles => Proc.new { |a| a.instance.file_styles },
    :default_style => :product,
    :url => "/spree/products/:id/:style/:basename.:extension",
    :path => ":rails_root/public/spree/products/:id/:style/:basename.:extension",
    :convert_options => { :all => '-strip -auto-orient' }
    )
    
    # if this is a custom tea then use the composite processor as well
    def processors
      logger.debug("********** determining which image processors to use")
      variant = Spree::Variant.find_by_id(viewable_id)
      if variant and variant.is_custom?
        logger.debug("********** using composite and thumbnail")
        [:composite, :thumbnail]
      else
        logger.debug("********** using only thumbnail")
        [:thumbnail]
      end
    end
    
    def file_styles
      {
      :mini => {
        :geometry => '48x48>',
        :format => :png,        
        :template_path => "#{Rails.root.to_s}/public/images/templates/template-white.png",
        :variant_id => viewable_id,
        :label_image_remote_url => label_image_remote_url,
      },
      :small => {
        :geometry => '100x100>',
        :format => :png,
        :template_path => "#{Rails.root.to_s}/public/images/templates/template-white.png",
        :variant_id => viewable_id,
        :label_image_remote_url => label_image_remote_url,
      },
      :product => {
        :geometry => '240x240>',
        :format => :png,
        :template_path => "#{Rails.root.to_s}/public/images/templates/template-white.png",
        :variant_id => viewable_id,
        :label_image_remote_url => label_image_remote_url,
      },
      :large => {
        :geometry => '600x600>',
        :format => :png,
        :template_path => "#{Rails.root.to_s}/public/images/templates/template-white.png",
        :variant_id => viewable_id,
        :label_image_remote_url => label_image_remote_url,
      }
    }
    end
  protected

  def label_image_url_provided?
    !label_image_remote_url.blank?
  end
      
  def download_remote_image
    self.attachment = do_download_remote_image(label_image_remote_url)
  end

  def do_download_remote_image
    logger.debug("********** downloading " + label_image_remote_url)
    io = open(URI.parse(label_image_remote_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  #rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
end