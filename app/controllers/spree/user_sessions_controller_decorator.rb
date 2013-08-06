Spree::UserSessionsController.class_eval do
  def redirect_back_or_default(default)
    logger.debug "******** redirect_back_or_default location = " + (session["spree_user_return_to"] || default)
    redirect_to(session["spree_user_return_to"] || default)
    session["spree_user_return_to"] = nil
  end
end