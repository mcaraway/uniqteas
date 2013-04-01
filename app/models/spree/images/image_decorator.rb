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
    logger.debug("********** viewable_id = " + (viewable_id.blank? ? "nil" : viewable_id.to_s))
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
        :tin_path => "#{Rails.root.to_s}/public/images/templates/TeaTin.png",
        :tin_fade_path => "#{Rails.root.to_s}/public/images/templates/TeaTinLabelFade.png",
        :label_template_path => "#{Rails.root.to_s}/public/images/templates/LabelTemplate.png",
        :variant_id => viewable_id,
        :label_image_remote_url => label_image_remote_url,
        :generate_tin_image => true,
      },
      :small => {
        :geometry => '100x100>',
        :tin_path => "#{Rails.root.to_s}/public/images/templates/TeaTin.png",
        :tin_fade_path => "#{Rails.root.to_s}/public/images/templates/TeaTinLabelFade.png",
        :label_template_path => "#{Rails.root.to_s}/public/images/templates/LabelTemplate.png",
        :variant_id => viewable_id,
        :label_image_remote_url => label_image_remote_url,
        :generate_tin_image => true,
      },
      :product => {
        :geometry => '240x240>',
        :tin_path => "#{Rails.root.to_s}/public/images/templates/TeaTin.png",
        :tin_fade_path => "#{Rails.root.to_s}/public/images/templates/TeaTinLabelFade.png",
        :label_template_path => "#{Rails.root.to_s}/public/images/templates/LabelTemplate.png",
        :variant_id => viewable_id,
        :label_image_remote_url => label_image_remote_url,
        :generate_tin_image => true,
      },
      :large => {
        :geometry => '600x600>',
        :tin_path => "#{Rails.root.to_s}/public/images/templates/TeaTin.png",
        :tin_fade_path => "#{Rails.root.to_s}/public/images/templates/TeaTinLabelFade.png",
        :label_template_path => "#{Rails.root.to_s}/public/images/templates/LabelTemplate.png",
        :variant_id => viewable_id,
        :label_image_remote_url => label_image_remote_url,
        :generate_tin_image => true,
      },
      :label => {
        :geometry => '450x600>',
        :tin_path => "#{Rails.root.to_s}/public/images/templates/TeaTin.png",
        :tin_fade_path => "#{Rails.root.to_s}/public/images/templates/TeaTinLabelFade.png",
        :label_template_path => "#{Rails.root.to_s}/public/images/templates/LabelTemplate.png",
        :variant_id => viewable_id,
        :label_image_remote_url => label_image_remote_url,
        :generate_tin_image => false,
      }
    }
  end

  if Rails.env.production?
    include Spree::Core::S3Support
    supports_s3 :attachment
  end

  def download_image(remote_url)
    self.attachment = do_download_remote_image(remote_url)
  end

  def download_remote_image
    self.attachment = do_download_remote_image(label_image_remote_url)
  end

  protected

  def label_image_url_provided?
    !label_image_remote_url.blank?
  end

  def do_download_remote_image(remote_url)
    puts "****** downloading " + (remote_url.nil?  ? "nil" : remote_url)
    io = open(URI.parse(remote_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  #rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
end