Spree::Product.class_eval do
  belongs_to :user

  attr_accessible :public, :final 
  
  validate :validate_minimum_image_size
  validate :must_have_blend
  validate :check_final_state
  
  def validate_minimum_image_size
    if (! @tin_image.nil?)
      unless (@tin_image.attachment_width == 450 && @tin_image.attachment_height == 600 )
        logger.debug "*** Naughty you... the tin image designs should be 450px x 600px."
        errors.add :tin_image, "Naughty you... the tin image designs should be 450px x 600px."
      end
    end

    if (! @tag_image.nil?)
      unless (@tag_image.attachment_width == 120 && @tag_image.attachment_height == 100 )
        logger.debug "*** Naughty you... the tag image designs should be 120px x 100px."
        errors.add :tag_image, "Naughty you... the tag image designs should be 120px x 100px."
      end
    end
  end

  def is_public?
    public
  end

  def check_final_state
    if final 
      if name == nil or description == nil or images.length < 2 or !has_flavors?  
        errors.add :blend, "You blend can not be made final until it has a name, description, at least one flavor, and both images."
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
      if (property.property_name.index("percent") == nil)
        product_properties.each do |percent_property|
          if (percent_property.property_name == property.property_name+"percent")
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
    images.empty??false:true
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