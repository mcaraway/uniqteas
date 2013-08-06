Spree::Core::ControllerHelpers::Auth.class_eval do
  def store_location
    logger.debug "******** storing location = " + request.fullpath
    # disallow return to login, logout, signup pages
    authentication_routes = [:spree_signup_path, :spree_login_path, :spree_logout_path]
    disallowed_urls = []
    authentication_routes.each do |route|
      if respond_to?(route)
        disallowed_urls << send(route)
      end
    end

    disallowed_urls.map!{ |url| url[/\/\w+$/] }
    unless disallowed_urls.include?(request.fullpath)
      session['spree_user_return_to'] = request.fullpath.gsub('//', '/')
    end
  end

  def redirect_back_or_default(default)
    logger.debug "******** redirect_back_or_default location = " + (session["user_return_to"] || default)
    redirect_to(session["user_return_to"] || default)
    session["user_return_to"] = nil
  end
end