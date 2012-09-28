module Spree
  class  CustomProduct < Spree::Product
    # validates :prototype_id, :presence =>true
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
              blend += percent_property.value + " " +
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
  end
end