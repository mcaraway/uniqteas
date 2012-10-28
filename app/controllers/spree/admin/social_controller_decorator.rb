Spree::Admin::SocialController.class_eval do
  def update
    params[:social].each do |provider, value|
      if value == '1'
        Spree::Config["#{provider}_button"] = true
      else
        Spree::Config["#{provider}_button"] = false
      end
    end

    Spree::Config["facebook_app_id"] = params[:facebook_app_id]
    redirect_to edit_admin_social_path, :notice => t("social_sharing_settings_updated")
  end
end 