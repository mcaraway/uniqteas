Spree::ProductsController.class_eval do
  before_filter :create_custom_product, :only => :create
  before_filter :load_product, :only => [:show, :edit, :update]
  before_filter :verify_login?, :only => [:new]
  before_filter :load_blendables, :only => [:new, :edit]

  respond_to :html, :json, :js
  def customize

  end

  def index
    params[:ispublic] = true
    params[:iscustom] = params[:iscustom] == nil ? "false" : params[:iscustom]
    logger.debug "****** Prototype is #{params}"
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products

    respond_with(@products)
  end

  def new
    @first_flavor = params[:flavor1]
    @prototype = Spree::Prototype.find_by_name("CustomTea")
    @product = Spree::Product.new(:price => 14.95 )
    @product.public = true
    @flavor_count = 3
    logger.debug "****** Prototype is #{@prototype.properties}"

    @prototype.properties.each do |property|
      logger.debug "****** setting property  #{property}"
      @product.product_properties.build( :property_name => property.name )
    end

    logger.debug "****** custom_product properties are now #{@product.product_properties}"
  end

  def edit
    if @product.is_custom? then
      @edit_blend = true
      if try_spree_current_user == nil or (try_spree_current_user != nil and try_spree_current_user.id != @product.user.id) then
        render @product
      end
    end
  end

  def create
    logger.debug "****** custom_product name is #{@product.name}"
    @product.user = try_spree_current_user
    @product.sku = get_custom_sku
    @product.shipping_category = Spree::ShippingCategory.find_by_name("Default Shipping")
    @product.tax_category= Spree::TaxCategory.find_by_name("Food")
    @product.weight = 0.5
    @product.height = 6
    @product.width = 2.6
    @product.depth = 2.6
    @product.price = 12.95
    @product.available_on = Time.now.getutc
    @product.final = false
    @product.public = params[:product][:public]
    @product.on_hand = 999999
    @product.meta_keywords = t(:custom_blend_meta_keywords)
    @product.meta_description = t(:custom_blend_meta_description)

    @custom_tea_taxon = Spree::Taxon.find_by_name("Custom Blends");
    @product.taxons = [@custom_tea_taxon] if @custom_tea_taxon

    if @product.save
      @product.update_viewables
      create_default_image
      flash[:success] = "Your draft blend is saved.  Now add some art and click Finalize to be able to order it."
      redirect_to proc { edit_product_url(@product) }
    else
      load_blendables
      render :new
    end
  end

  def create_default_image
    url = "#{Rails.root}/public/images/templates/your-image-here.jpg"
    logger.debug("************** url = " + url)
    image = Spree::Image.new
    image.viewable_type = 'Spree::Variant'
    image.alt = @product.name
    image.viewable_id = @product.master.id
    image.attachment = File.open(url)
    image.save!
  end

  def setup_volume_pricing
    create_volume_price("Low","1..19",12.95,1,@product.master)
    create_volume_price("Med","20..49",11.65,2,@product.master)
    create_volume_price("High","50..99",10.50,3,@product.master)
    create_volume_price("X High","100..199",9.45,4,@product.master)
    create_volume_price("XX High","200+",8.50,5,@product.master)
  end

  def create_volume_price (name, range, amount, position, variant)
    volume = Spree::VolumePrice.new
    volume.name = name
    volume.range = range
    volume.amount = amount
    volume.position = position
    volume.variant_id = variant.id
    volume.discount_type = "price"
    volume.save
  end

  def update
    @edit_blend = true
    if @product.update_attributes(params[:product])
      @product.update_viewables

      if try_spree_current_user.guest?
        flash[:success] = "Your blend is ready.  Just create an account so we can order your unique blend."
      elsif @product.final == false
        flash[:success] = "Your draft blend is saved."
      else
        link = "<a href=\"#{url_for(@product)}\">order</a>"
        flash[:success] = "<h2>Your blend is good to go! Now go #{link} some.</h2>".html_safe
      end
      logger.debug "******* try_spree_current_user.guest? = " + try_spree_current_user.guest?.to_s
      if try_spree_current_user.guest?
        remember_guest
        redirect_to proc { login_url }
      elsif @product.final 
        redirect_to proc { product_url(@product) }
      else
        redirect_to proc { edit_product_url(@product) }
      end
    else
      load_blendables
      @product.final = @product.final_was
      respond_with(@product)
    end
  end
  
  def remember_guest
    if try_spree_current_user.guest?
      logger.debug "******* in remember_guest try_spree_current_user.guest? = " + try_spree_current_user.guest?.to_s
      session['guest_user'] = try_spree_current_user.id.to_s
      sign_out(try_spree_current_user)
      flash[:warning] = "If you cancel now you will lose your blend."
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

    logger.debug "****** count Products with sku CUST% = #{count}"

    new_sku = "CUST_"+count.to_s().rjust(8, '0')

    new_sku
  end

  def load_product
    @product = Spree::Product.find_by_permalink!(params[:id])
  end

  def verify_login?
    if try_spree_current_user == nil
      @user = Spree::User.create_guest_user
      if @user.save
        sign_in(:spree_user, @user)
        session[:spree_user_signup] = true
        associate_user
      else
        load_blendables
        render :new
      end
    end
  end

  def load_blendables
    @blendables = Spree::BlendableTaxon.all
    @black_teas = Spree::BlendableTaxon.find_by_name("Black Tea")
    @fruit_teas = Spree::BlendableTaxon.find_by_name("Fruit Tea")
    @herbal_teas = Spree::BlendableTaxon.find_by_name("Herbal Tea")
    @green_teas = Spree::BlendableTaxon.find_by_name("Green Tea")
    @white_teas = Spree::BlendableTaxon.find_by_name("White Tea")
  end
end