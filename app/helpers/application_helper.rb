module ApplicationHelper
  def title
    base_title = "UniqTeas"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"   
    end 
  end
  
  def meta_data_tags
    object = instance_variable_get('@'+controller_name.singularize)
    meta = {}

    if object.kind_of? ActiveRecord::Base
      meta[:keywords] = object.meta_keywords if object[:meta_keywords].present?
      meta[:description] = object.meta_description if object[:meta_description].present?
    end

    if meta[:description].blank? && object.kind_of?(Spree::Product)
      meta[:description] = strip_tags(object.description)
    end

    meta.reverse_merge!({
      :keywords => Spree::Config[:default_meta_keywords],
      :description => Spree::Config[:default_meta_description]
    })

    meta.map do |name, content|
      tag('meta', :name => name, :content => content)
    end.join("\n")
  end
  
  def logo(image_path=Spree::Config[:logo])
      link_to image_tag(image_path), "/"
  end
  
  def flash_messages
    flash.each do |msg_type, text|
      concat(content_tag :div, text, :class => "flash #{msg_type}") unless msg_type == :commerce_tracking
    end
    nil
  end  
end
