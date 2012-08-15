class CustomProductsController < ApplicationController
  layout '/spree/layouts/custom_product_application'
  before_filter :create_custom_product
  before_filter :load_product, :only => :show
    
  respond_to :html
  def new
    @prototype = Spree::Prototype.find_by_name("CustomTea")
    @custom_product = CustomProduct.new(:price => 14.95 )
    @flavor_count = 3
    logger.debug "*** Prototype is #{@prototype.properties}" 
    
    @prototype.properties.each do |property| 
      logger.debug "*** setting property  #{property}"
      @custom_product.product_properties.build( :property_name => property.name )
    end
    
    logger.debug "*** custom_product properties are now #{@custom_product.product_properties}"
  end
  
  def show
    
  end
  
  def create
    @custom_product.sku = get_custom_sku
    @custom_product.shipping_category = Spree::ShippingCategory.find_by_name("Default Shipping")
    @custom_product.tax_category= Spree::TaxCategory.find_by_name("Food")
    @custom_product.weight = 0.5
    @custom_product.height = 6
    @custom_product.width = 2.6
    @custom_product.depth = 2.6
    @custom_product.available_on = Time.now.getutc
    
    if @custom_product.save
      @custom_product.update_viewables
      flash[:success] = "Your product is good to go!"
      redirect_to @custom_product
    else
      render 'new'
    end
  end

  def show
    return unless @custom_product

    @variants = Spree::Variant.active.includes([:option_values, :images]).where(:product_id => @custom_product.id)
    @product_properties = Spree::ProductProperty.includes(:property).where(:product_id => @custom_product.id)

    referer = request.env['HTTP_REFERER']
    if referer
      referer_path = URI.parse(request.env['HTTP_REFERER']).path
      if referer_path && referer_path.match(/\/t\/(.*)/)
        @taxon = Spree::Taxon.find_by_permalink($1)
      end
    end

    respond_with(@custom_product)
  end
   
  def product_image(product, item_prop)
    image_tag(product.images.first, :item_prop => item_prop)
  end
  
  private
  
    def create_custom_product
      @custom_product = CustomProduct.new(params[:custom_product])
    end
    
    def get_custom_sku
      count = Spree::Variant.count_by_sql("select count(*) from spree_variants where sku like 'CUST%'")
      
      logger.debug "*** count Products with sku CUST% = #{count}"
      
      new_sku = "CUST_"+count.to_s().rjust(8, '0')
      
      new_sku;
    end
    
    def load_product
      @custom_product = CustomProduct.active.find_by_permalink!(params[:id])
    end
end
