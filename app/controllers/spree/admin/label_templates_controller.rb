# encoding: utf-8
require 'net/http'

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

      def reprocess_images
        logger.debug("************ entered  reprocess_images")
        @products = Spree::Product.all

        @products.each do |product|
          if product.is_custom?
          next
          end
          logger.debug("************ reprocessing " + product.name)
          url = generate_file_name(product)

          if !validate_uri_existence_of(url)
          next
          end
          image = product.images.blank? ? Spree::Image.new : product.images[0]

          image.viewable_type = 'Spree::Variant'
          image.download_image(url)
          image.alt = product.name
          image.viewable_id = product.master.id
          success = image.save!
        end

        respond_to do |format|
          format.html { redirect_to admin_products_url }
          format.js   { render :layout => false }
        end
      end

      # encoding: utf-8
      def generate_file_name(product)
        cleaned_name = product.name.downcase
        cleaned_name = cleaned_name.tr("w/","with").tr(" / ", "-").tr("/","-").tr(" ", "-").tr(" - ", "-").tr("&","and")
        cleaned_name = cleaned_name.chomp("'").chomp("?").chomp(".")

        # encoding: utf-8
        character_table = {'Š'=>'S', 'š'=>'s', 'Ð'=>'Dj','Ž'=>'Z', 'ž'=>'z', 'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A',
          'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E', 'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I',
          'Ï'=>'I', 'Ñ'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O', 'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U', 'Ú'=>'U',
          'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss','à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a',
          'å'=>'a', 'æ'=>'a', 'ç'=>'c', 'è'=>'e', 'é'=>'e', 'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i',
          'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ò'=>'o', 'ó'=>'o', 'ô'=>'o', 'õ'=>'o', 'ö'=>'o', 'ø'=>'o', 'ù'=>'u',
          'ú'=>'u', 'û'=>'u', 'ý'=>'y', 'ý'=>'y', 'þ'=>'b', 'ÿ'=>'y', 'ƒ'=>'f'}
        regexp_keys = Regexp.union(character_table.keys)
        cleaned_name = cleaned_name.gsub(regexp_keys, character_table)

        url = "http://s3.amazonaws.com/carawaytea/images/products/#{cleaned_name}.jpg"

        logger.debug("************ URL = " + url)
        url
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

      def validate_uri_existence_of(url)
        begin # check header response
          case Net::HTTP.get_response(URI.parse(url))
          when Net::HTTPSuccess then true
          else  false
          end
        rescue # Recover on DNS failures..
        false
        end
      end
    end
  end
end