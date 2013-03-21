module Spree
  module Admin
    class LabelTemplatesController < Spree::Admin::ResourceController
      before_filter :load_data
      def refresh_labels
        logger.debug("************ entered  refresh_labels_before")
        @label_templates = Spree::LabelTemplate.all

        @label_templates.each do |template|
          logger.debug("************ reprocessing " + template.name)
          template.label_image.reprocess!
        end
        respond_to do |format|
          format.html { redirect_to location_after_save }
          format.js   { render :layout => false }
        end
      end

      protected

      def location_after_save
        admin_label_templates_url
      end

      private

      def load_data
        #@label_template = Spree::LabelTemplate.find_by_id(params[:id])

        @label_templates = Spree::LabelTemplate.all
        @label_groups = Hash.new
        @label_templates.each do |template|
          group = @label_groups[template.group]
          group = group == nil ? [] : group
          group << template
          @label_groups[template.group] = group
        end
      end
    end
  end
end