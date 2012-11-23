Spree::UserSessionsController.class_eval do
  def create
    authenticate_user!

    if user_signed_in?
      respond_to do |format|
        format.html {
          flash.notice = t(:logged_in_succesfully)
          redirect_back_or_default(root_path)
        }
        format.js {
          user = resource.record
          render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
        }
        format.mobile {
          flash.notice = t(:logged_in_succesfully)
          redirect_back_or_default(root_path)
        }
      end
    else
      flash.now[:error] = t('devise.failure.invalid')
      render :new
    end
  end
end