require 'open-uri'

class Spree::ProductLabel < ActiveRecord::Base
  before_validation :download_remote_image, :if => :label_image_url_provided?
  validates_presence_of :label_image_remote_url, :if => :label_image_url_provided?, :message => 'is invalid or inaccessible'

  belongs_to :product
  belongs_to :label_template

  delegate_belongs_to :label_template, :name

  attr_accessible :group, :name, :label_image, :label_template_id, :product_id, :label_image_file_name,:label_image_remote_url

  has_attached_file(
    :label_image,
    :processors => [:label_image_processor, :thumbnail],
    :styles => Proc.new { |a| a.instance.file_styles },
    :default_style => :product,
    :url => "/spree/product_labels/:id/:style/:basename.:extension",
    :path => ":rails_root/public/spree/product_labels/:id/:style/:basename.:extension",
    :convert_options => { :all => '-strip -auto-orient' }
    )

  # save the w,h of the original image (from which others can be calculated)
  # we need to look at the write-queue for images which have not been saved yet

  include Spree::Core::S3Support
  supports_s3 :label_image
  # Spree::LabelTemplate.attachment_definitions[:label_image][:styles] = { :label  => '600x800', :thumb => '75x100' }
  # Spree::LabelTemplate.attachment_definitions[:label_image][:path] = ":rails_root/public/spree/label_templates/:id/:style/:basename.:extension"
  # Spree::LabelTemplate.attachment_definitions[:label_image][:url] = "/spree/label_templates/:id/:style/:basename.:extension"
  # Spree::LabelTemplate.attachment_definitions[:label_image][:default_url] = "/spree/label_templates/:id/:style/:basename.:extension"
  # Spree::LabelTemplate.attachment_definitions[:label_image][:default_style] = "label"
  # if this is a custom tea then use the composite processor as well

  def file_styles
    {
      :mini => {
        :geometry => '48x48>',
        :format => :png,
        :name => product.name,
        :description => product.description,
        :template_path => "#{Rails.root.to_s}/public/images/templates/template-white.png",
        :generate_tin_image => true,
      },
      :small => {
        :geometry => '100x100>',
        :format => :png,
        :name => product.name,
        :description => product.description,
        :template_path => "#{Rails.root.to_s}/public/images/templates/template-white.png",
        :generate_tin_image => true,
      },
      :product => {
        :geometry => '240x240>',
        :format => :png,
        :name => product.name,
        :description => product.description,
        :template_path => "#{Rails.root.to_s}/public/images/templates/template-white.png",
        :generate_tin_image => true,
      },
      :large => {
        :geometry => '600x600>',
        :format => :png,
        :name => product.name,
        :description => product.description,
        :template_path => "#{Rails.root.to_s}/public/images/templates/template-white.png",
        :generate_tin_image => true,
      }
    }
  end

  def find_dimensions
    temporary = label_image.queued_for_write[:original]
    filename = temporary.path unless temporary.nil?
    filename = label_image.path if filename.blank?
    geometry = Paperclip::Geometry.from_file(filename)
    self.label_image_width  = geometry.width
    self.label_image_height = geometry.height
  end

  # if there are errors from the plugin, then add a more meaningful message
  def no_attachment_errors
    unless label_image.errors.empty?
      # uncomment this to get rid of the less-than-useful interrim messages
      # errors.clear
      errors.add :label_image, "Paperclip returned errors for file '#{label_image_file_name}' - check ImageMagick installation or image source file."
    false
    end
  end

  protected

  def label_image_url_provided?
    !label_image_remote_url.blank?
  end

  def download_remote_image
    self.label_image = do_download_remote_image
  end

  def do_download_remote_image
    logger.debug("********** downloading " + label_image_remote_url)
    io = open(URI.parse(label_image_remote_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  #rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
end
