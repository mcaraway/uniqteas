class Spree::UserProductsController < ApplicationController
  # GET /user_products
  # GET /user_products.json
  def index
    @user_products = UserProduct.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_products }
    end
  end

  # GET /user_products/1
  # GET /user_products/1.json
  def show
    @user_product = UserProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_product }
    end
  end

  # GET /user_products/new
  # GET /user_products/new.json
  def new
    @user_product = UserProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_product }
    end
  end

  # GET /user_products/1/edit
  def edit
    @user_product = UserProduct.find(params[:id])
  end

  # POST /user_products
  # POST /user_products.json
  def create
    @user_product = UserProduct.new(params[:user_product])

    respond_to do |format|
      if @user_product.save
        format.html { redirect_to @user_product, notice: 'User product was successfully created.' }
        format.json { render json: @user_product, status: :created, location: @user_product }
      else
        format.html { render action: "new" }
        format.json { render json: @user_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_products/1
  # PUT /user_products/1.json
  def update
    @user_product = UserProduct.find(params[:id])

    respond_to do |format|
      if @user_product.update_attributes(params[:user_product])
        format.html { redirect_to @user_product, notice: 'User product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_products/1
  # DELETE /user_products/1.json
  def destroy
    @user_product = UserProduct.find(params[:id])
    @user_product.destroy

    respond_to do |format|
      format.html { redirect_to user_products_url }
      format.json { head :no_content }
    end
  end
end
