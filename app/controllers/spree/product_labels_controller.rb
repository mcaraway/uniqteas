class Spree::ProductLabelsController < Spree::ResourceController
  include Spree::Core::ControllerHelpers::Order
  before_filter :load_data
  create.before :create_before
  
  def location_after_save
    edit_product_url(@product)
  end

  # GET /product_labels
  # GET /product_labels.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @label_templates }
    end
  end

  def show
    @product_label = Spree::ProductLabel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product_label }
    end
  end
  
  def create_before
    url = params[:product_label][:label_image_remote_url]
    @object.label_image_remote_url=root_url + url[1,url.length-1]
    logger.debug("********** url " + @object.label_image_remote_url)

  end

  protected

  def load_data
    @current_category = params[:c]
    @product = Spree::Product.find_by_permalink(params[:product_id])
    @label_templates = Spree::LabelTemplate.all
    @label_groups = Hash.new
    @label_templates.each do |template|
      group = @label_groups[template.group]
      group = group == nil ? [] : group
      group << template
      @label_groups[template.group] = group
    end

    if (@current_category)
      @label_templates = @label_groups[@current_category]
    end
    @label_templates = Kaminari.paginate_array(@label_templates).page(params[:page]).per(Spree::Config.products_per_page)
  end
end
