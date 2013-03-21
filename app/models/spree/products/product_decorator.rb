Spree::Product.class_eval do
  belongs_to :user
  has_and_belongs_to_many :blendable_taxons, :join_table => 'spree_blendable_products_taxons'
  has_one :product_label
  
  attr_accessible :public, :final, :label_template_id

  validate :validate_minimum_image_size
  validate :must_have_blend
  validate :check_final_state
  def validate_minimum_image_size
    if is_custom?
      requiredTinImageWidth = 347
      requiredTinImageHeight = 300
      requiredTagImageWidth = 120
      requiredTagImageHeight = 100
      if (! @tin_image.nil?)
        unless (@tin_image.attachment_width == requiredTinImageWidth && @tin_image.attachment_height == requiredTinImageHeight )
          logger.debug "*** Naughty you... the tin image designs should be #{requiredTinImageWidth}px x #{requiredTinImageHeight}px."
          errors.add :tin_image, "Naughty you... the tin image designs should be #{requiredTinImageWidth}px x #{requiredTinImageHeight}px."
        end
      end

      if (! @tag_image.nil?)
        unless (@tag_image.attachment_width == requiredTagImageWidth && @tag_image.attachment_height == requiredTagImageHeight )
          logger.debug "*** Naughty you... the tag image designs should be #{requiredTagImageWidth}px x #{requiredTagImageHeight}px."
          errors.add :tag_image, "Naughty you... the tag image designs should be #{requiredTagImageWidth}px x #{requiredTagImageHeight}px."
        end
      end
    end
  end

  def label_template_id=(params) 
    label_template_id = params[:label_template_id]
    label_template = Spree::LabelTemplate.find_by_id(label_template_id)
    product_label = Spree::ProductLabel.new
    
    product_label.label_template = label_template
    product_label.product = self
    url = label_template.url(:label)
    url=root_url + url[1,url.length-1]
    logger.debug "************ url = " + url
    product_label.label_template_template_remote_url = url
  end
  
  def label_template_id
    
  end
  
  def requiredTinImageWidth
    347
  end

  def requiredTinImageHeight
    300
  end

  def is_public?
    public
  end

  def check_final_state
    if is_custom?
      if final
        if name == nil
          errors.add :name, "You blend can not be made final until it has a name."
        end
        if description == nil
          errors.add :description, "You blend can not be made final until it has a description."
        end
        if !(has_tin_image?)
          errors.add :images, "You blend can not be made final until it has a tin image."
        end
        if !has_flavors?
          errors.add :blend, "You blend can not be made final until it has at least one flavor."
        end
      end
    end
  end

  def has_flavors?
    @has_flavors = false
    product_properties.each do |property|

      if (property.property_name.index("percent") == nil)
        if property.value != nil and property.value != ""
          @has_flavors = true
        end
      end
      logger.debug "*** Hasflavors #{@has_flavors}"
    end
    @has_flavors
  end

  add_search_scope :ispublic do |value|
    logger.debug "****** :public search is #{value}"
    value = value == nil ? true : value
    where(:public => value)
  end

  add_search_scope :isfinal do |value|
    logger.debug "****** :final search is #{value}"
    value = value == nil ? true : value
    where(:final => value)
  end

  def is_custom?
    user_id == nil ? false: true
  end

  def new_product_property=(product_property_attributes)
    logger.debug "Setting attributes #{product_property_attributes}"
    product_property_attributes.each do |attributes|
      product_properties.build(attributes)
    end
  end

  def blend
    blend = ""
    product_properties.each do |property|
      if (property.property_name.index("name") != nil)
        prefix = property.property_name[0, 7]
        product_properties.each do |percent_property|
          if (percent_property.property_name == prefix+"percent" and percent_property.value != "0")
            blend += percent_property.value + "% " +
            property.value + " / "
          end
        end
      end
    end

    if (blend =~ / \/ $/)
    blend = blend.slice(0,blend.length-3)
    end
    blend
  end

  def has_tin_image?
    !(images.empty?)
  end

  def has_tag_image?
    images.length > 1
  end

  def tin_image
    if images.empty?
      image_tag "/assets/CustomTeaLabel.png", :size => "82x186"
    else
      image_tag images.first.attachment.url(:small), :size => "82x186"
    end
  end

  def tag_image
    if images.empty? or images.length < 2
      image_tag "/assets/TeaTagLabel.png", :size => "50x42"
    else
      image_tag images[1].attachment.url(:small), :size => "50x42"
    end
  end

  def tin_image=(params)
    @tin_image = Spree::Image.create( params )
  end

  def tag_image=(params)
    @tag_image = Spree::Image.create( params )
  end

  def update_viewables
    if @tin_image != nil
      @tin_image.viewable = master
    @tin_image.save
    end

    if @tag_image != nil
      @tag_image.viewable = master
    @tag_image.save
    end
  end
  attr_accessible :tin_image, :tag_image, :blend

  def must_have_blend
    if !has_flavors? && is_custom?
      logger.debug "You must have at least one flavor"
      errors.add :blend, "You must have at least one flavor"
    end
  end
end