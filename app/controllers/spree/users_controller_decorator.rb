Spree::UsersController.class_eval do
  def show
    @user ||= current_user
    logger.debug "*** user  #{@user.email}"
    @myblends = Kaminari.paginate_array(@user.myproducts).page(params[:page]).per(Spree::Config.products_per_page) 
  end
  
  def myblends
    @user ||= current_user
    logger.debug "*** user  #{@user.email}"
    @myblends = Kaminari.paginate_array(@user.myproducts).page(params[:page]).per(Spree::Config.products_per_page) 
  end
end