class Spree::Admin::LabelTemplatesController < Spree::Admin::ResourceController
  before_filter :load_data

  protected
  def location_after_save
    edit_admin_label_template_url(@label_template)
  end

  def load_data
    @label_template = Spree::LabelTemplate.find_by_id(params[:id])
    if @label_template 
      logger.debug "*********** label_template = " + @label_template.name
      logger.debug "*********** label_template.image = " + @label_template.label_image.url
    end
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
