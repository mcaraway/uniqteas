module Spree
  module Admin
    module LabelTemplatesHelper
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

      def link_to_image_med(label_template)
        link_to med_label_image(label_template), label_template.label_image.url
      end

      def med_label_image(label_template, options = {})
        if label_template.label_image == nil
          image_tag "noimage/no-tin-image.png", :size => "150x200", :alt => label_template.name
        else
          image = label_template.label_image
          options.reverse_merge! :alt => label_template.name
          options.reverse_merge! :size => "150x200"
          image_tag label_template.label_image.url, options
        end
      end
    end
  end
end
