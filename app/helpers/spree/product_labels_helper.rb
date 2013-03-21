module Spree
  module ProductLabelsHelper
    def label_groups_for(label_template)

      options = @label_groups.keys.map do |group|
        logger.debug("************** select group = " + group )
        selected = label_template.group == group
        content_tag(:option,
                      :value => group,
                      :selected => ('selected' if selected)) do
          group
        end
      end.join("").html_safe

      logger.debug("************** options = " + options )
      options
    end

    def get_product_label(id)
      Spree::ProductLabel.find_by_id(id)
    end

    def link_to_image_med(product_label)
      link_to med_label_image(product_label), product_label.label_image.url
    end

    def med_label_image(product_label, options = {})
      if product_label == nil or product_label.label_image == nil
        image_tag "store/no-template.png", :size => "150x200"
      else
        image = product_label.label_image
        options.reverse_merge! :alt => product_label.name
        options.reverse_merge! :size => "150x200"
        image_tag product_label.label_image.url, options
      end
    end

    def large_label_image(product_label, options = {})
      if product_label == nil or product_label.label_image == nil
        image_tag "store/no-template.png", :size => "225x300"
      else
        image = product_label.label_image
        options.reverse_merge! :alt => product_label.name
        options.reverse_merge! :size => "225x300"
        image_tag product_label.label_image.url, options
      end
    end

    def link_to_image_small(product_label)
      link_to small_label_image(product_label), product_label.label_image.url
    end

    def small_label_image(product_label, options = {})
      if product_label.label_image == nil
        image_tag "noimage/no-tin-image.png", :size => "100x133", :alt => product_label.name
      else
        image = product_label.label_image
        options.reverse_merge! :alt => product_label.name
        options.reverse_merge! :size => "100x133"
        image_tag product_label.label_image.url, options
      end
    end
  end
end
