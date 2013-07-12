source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.11'
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
  gem 'rspec-rails', '2.11.0'
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
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

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
gem 'jquery-rails', '2.2.0'
gem 'spree', '~> 1.3.0'
gem 'spree_auth_devise', :branch => "1-3-stable", :git => 'git://github.com/spree/spree_auth_devise'
gem 'spree_active_shipping', :branch => "1-3-stable", :git => "git://github.com/spree/spree_active_shipping"
gem 'active_shipping', :git => "git://github.com/Shopify/active_shipping"
gem "spree_paypal_express", :branch => "1-3-stable", :git => "git://github.com/spree/spree_paypal_express.git"
gem 'spree_gateway', :branch => "1-3-stable", :git => 'git://github.com/spree/spree_gateway.git' # make sure to include after spree
gem 'spree_volume_pricing', :branch => "1-3-stable", :git => 'git://github.com/spree/spree_volume_pricing.git'
gem "spree_social_products", :git => "git://github.com/spree/spree_social_products.git"
gem 'spree_address_book', :git => "git://github.com/romul/spree_address_book.git"
gem 'spree_print_invoice', :git => 'git://github.com/mcaraway/spree_print_invoice.git'
gem 'spree_contact_us', :git => 'git://github.com/sbeam/spree_contact_us.git'
gem "recaptcha", :require => "recaptcha/rails" # if you are using reCAPTCHA
#gem 'spree_uniqteas_theme', :path => '../spree_uniqteas_theme'
gem 'spree_uniqteas_theme', :git => 'git://github.com/mcaraway/spree_uniqteas_theme.git'
gem 'datashift', '~> 0.13.0'
gem 'datashift_spree', '~>0.5.0'