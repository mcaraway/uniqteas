# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
# Example:
# Uncomment to override the default site name.
  config.site_name = "Uniq Teas"
  config.products_per_page = 15

  Spree::ActiveShipping::Config.set(:ups_login => "caraway tea")
  Spree::ActiveShipping::Config.set(:ups_password => "B4radhur")
  Spree::ActiveShipping::Config.set(:ups_key => "8CA5E782B48C580A")
  Spree::ActiveShipping::Config.set(:usps_login => "193CARAW5093")
  Spree::ActiveShipping::Config.set(:origin_country => "US")
  Spree::ActiveShipping::Config.set(:origin_city => "Marlboro")
  Spree::ActiveShipping::Config.set(:origin_state => "NY")
  Spree::ActiveShipping::Config.set(:origin_zip => "12542")
  Spree::PrintInvoice::Config.set(:print_invoice_logo_path => "logo.png")
end
