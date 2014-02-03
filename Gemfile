source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '4.0.0'
gem 'pg'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'closure-compiler'
gem 'delayed_job_active_record'
group :production do
  platforms :ruby do # linux
    gem 'unicorn'
  end
  gem 'dalli'
  gem 'newrelic_rpm'
end

group :development do
  gem 'sqlite3'
  gem 'rspec-rails', '2.14.0'
end

group :staging do
  platforms :ruby do # linux
    gem 'unicorn'
  end  
  gem 'memcachier'
  gem 'dalli'
  gem 'newrelic_rpm'
end
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails', '~> 4.0.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.4'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
gem 'jquery-rails', '3.0.0'
gem 'spree', '~> 2.1.0'
gem 'spree_auth_devise', :branch => "2-1-stable", :git => 'git://github.com/spree/spree_auth_devise'
gem 'spree_active_shipping', :branch => "2-1-stable", :git => "git://github.com/spree/spree_active_shipping"
gem 'active_shipping', :git => "git://github.com/Shopify/active_shipping"
gem 'spree_gateway', :branch => "2-1-stable", :git => 'git://github.com/spree/spree_gateway.git' # make sure to include after spree
gem 'spree_volume_pricing', :branch => "2-1-stable", :git => 'git://github.com/spree/spree_volume_pricing.git'
gem "spree_social_products", :branch => "2-1-stable", :git => "git://github.com/spree/spree_social_products.git"
gem "recaptcha", :require => "recaptcha/rails" # if you are using reCAPTCHA
gem 'spree_multi_domain', :branch => "2-1-stable", :git => 'git://github.com/spree/spree-multi-domain.git'
gem 'spree_address_book', :branch => "2-1-stable", :git => "git://github.com/romul/spree_address_book.git"
gem 'spree_print_invoice', :branch => "2-1-stable", :git => 'git://github.com/spree/spree_print_invoice'
gem "spree_paypal_express", :branch => "2-1-stable", :git => "git://github.com/radar/better_spree_paypal_express.git"

# my custom code
#gem 'spree_address_book', :path => '../spree_address_book'
#gem 'spree_address_book', :branch => "2-0-stable", :git => "git://github.com/mcaraway/spree_address_book.git"
gem 'spree_email_invoices', :branch => "2-1-stable", :git => "git://github.com/mcaraway/spree_email_invoices.git"
# gem 'spree_email_invoices', :path => '../spree_email_invoices'
gem 'spree_contact_us', :branch => "2-1-stable", :git => 'git://github.com/mcaraway/spree_contact_us.git'
# gem 'spree_contact_us', :path => '../spree_contact_us'
#gem "spree_paypal_express", :branch => "2-1-stable", :git => "git://github.com/mcaraway/better_spree_paypal_express.git"
# gem 'spree_paypal_express', :path => '../better_spree_paypal_express'
#gem 'spree_print_invoice', :git => 'git://github.com/mcaraway/spree_print_invoice.git'
# gem 'spree_print_invoice', :path => '../spree_print_invoice'
gem 'spree_custom_products', :branch => "2-1-stable", :git => 'git://github.com/mcaraway/spree_custom_products.git'
# gem 'spree_custom_products', :path => '../spree_custom_products'
gem 'spree_uniqteas_theme', :branch => "2-1-stable", :git => 'git://github.com/mcaraway/spree_uniqteas_theme.git'
# gem 'spree_uniqteas_theme', :path => '../spree_uniqteas_theme'
gem 'spree_reviews_rating', :branch => "2-1-stable", :git => 'git://github.com/mcaraway/spree_reviews_rating.git'
# gem 'spree_reviews_rating', :path => '../spree_reviews_rating'
#gem 'dynamic_sitemaps', :path => '../spree_dynamic_sitemaps'
#gem 'dynamic_sitemaps', :git => 'git://github.com/mcaraway/spree_dynamic_sitemaps.git'
gem 'spree_shipworks', :branch => "2-1-stable", :git => 'git://github.com/mcaraway/spree_shipworks.git'
# gem 'spree_shipworks', :path => '../spree_shipworks'
#gem 'spree_shipworks', :git => 'git://github.com/railsdog/spree_shipworks.git'
gem 'datashift', '~> 0.13.0'
gem 'datashift_spree', '~>0.5.0'