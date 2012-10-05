Spree::BaseHelper.class_eval do
  def small_image(product, options={})
    if product.images.empty?
      if product.is_custom? then
        image_tag "/assets/TeaTin-small.png", options
      else
        image_tag "noimage/small.jpg", options
      end
    else
      image_tag product.images.first.attachment.url(:small), options
    end
  end

  def small_tea_tin_image (product)
    if product.images.empty?
      image_tag "/assets/CustomTeaLabel.png", :size => "82x186"
    else
      image_tag product.images.first.attachment.url(:small), :size => "82x186"
    end
  end

  def small_tea_tag_image (product)
    if product.images[1] == nil
      image_tag "/assets/TeaTagLabel.png", :size => "50x42"
    else
      image_tag product.images[1].attachment.url(:small), :size => "50x42"
    end
  end

  def button(text, icon_name = nil, button_type = 'submit', options={})
    button_tag(content_tag('span', icon(icon_name) + ' ' + text), options.merge(:type => button_type))
  end

  def icon(icon_name)
    icon_name ? image_tag("admin/icons/#{icon_name}.png") : ''
  end
end