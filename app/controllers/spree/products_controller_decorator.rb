Spree::ProductsController.class_eval do
  before_filter :create_custom_product, :only => :create
  before_filter :load_product, :only => [:show, :edit, :update]
  before_filter :verify_login?, :only => [:new]
  
  
  def new
    @first_flavor = params[:flavor1]
    @prototype = Spree::Prototype.find_by_name("CustomTea")
    @product = Spree::Product.new(:price => 14.95 )
    @flavor_count = 3
    logger.debug "*** Prototype is #{@prototype.properties}"

    @prototype.properties.each do |property|
      logger.debug "*** setting property  #{property}"
      @product.product_properties.build( :property_name => property.name )
    end

    logger.debug "*** custom_product properties are now #{@product.product_properties}"
  end

  def edit
    if @product.is_custom? then
      logger.debug "*** current_user is #{current_user.email}"
      logger.debug "*** owner is #{@product.user.email}"
      @edit_blend = params[:edit_blend] == "true" ? true : false
      logger.debug "*** @edit_blend is #{@edit_blend}"
      if current_user == nil or (current_user != nil and current_user.id != @product.user.id) then
        redirect_to @product
      end
    end
  end

  def show

  end

  def create
    logger.debug "*** custom_product name is #{@product.name}"
    @product.sku = get_custom_sku
    @product.shipping_category = Spree::ShippingCategory.find_by_name("Default Shipping")
    @product.tax_category= Spree::TaxCategory.find_by_name("Food")
    @product.weight = 0.5
    @product.height = 6
    @product.width = 2.6
    @product.depth = 2.6
    @product.available_on = Time.now.getutc
    @product.price = 14.95

    if @product.save
      @product.update_viewables
      flash[:success] = "Your product is good to go!"
      redirect_to proc { edit_product_url(@product) }
    else
      render 'new'
    end
  end

  def update
    @product.update_viewables
    if @product.update_attributes(params[:product])
      flash[:success] = "Your product is good to go!"
      redirect_to proc { product_url(@product) }
    else
      redirect_to proc { edit_product_url(@product) }
    end
  end

  def show
    return unless @product

    @variants = Spree::Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
    @product_properties = Spree::ProductProperty.includes(:property).where(:product_id => @product.id)

    referer = request.env['HTTP_REFERER']
    if referer
      referer_path = URI.parse(request.env['HTTP_REFERER']).path
      if referer_path && referer_path.match(/\/t\/(.*)/)
        @taxon = Spree::Taxon.find_by_permalink($1)
      end
    end

    respond_with(@product)
  end

  def product_image(product, item_prop)
    image_tag(product.images.first, :item_prop => item_prop)
  end

    def redirect_back_or_default(default)
      redirect_to(session["user_return_to"] || default)
      session["user_return_to"] = nil
    end
  private

  def create_custom_product
    @product = Spree::Product.new(params[:product])
  end

  def get_custom_sku
    count = Spree::Variant.count_by_sql("select count(*) from spree_variants where sku like 'CUST%'")

    logger.debug "*** count Products with sku CUST% = #{count}"

    new_sku = "CUST_"+count.to_s().rjust(8, '0')

    new_sku;
  end

  def load_product
    @product = Spree::Product.active.find_by_permalink!(params[:id])
  end
  
  def verify_login?
    if current_user == nil
      store_location
      flash[:notice] = "Please create an account so we can save your blend."
      redirect_to spree.login_path
    end
  end

end