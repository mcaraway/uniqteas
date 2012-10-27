source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'active_shipping', :git => "git://github.com/Shopify/active_shipping"
gem 'spree_active_shipping', :git => "git://github.com/spree/spree_active_shipping"
gem 'spree_address_book', :git => "git://github.com/romul/spree_address_book.git"
gem "spree_paypal_express", :git => "git://github.com/spree/spree_paypal_express.git", :branch => '1-1-stable'
gem 'spree_volume_pricing', :git => 'git://github.com/spree/spree_volume_pricing.git'
gem 'spree_print_invoice' , :git => 'git://github.com/spree/spree_print_invoice.git', :branch => '1-1-stable'

group :development do
  gem 'sqlite3'  
  gem 'rspec-rails', '2.11.0'
end

group :production do
  gem 'spree_heroku', :git => 'git://github.com/joneslee85/spree-heroku.git', :branch => '1-0-stable'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

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
gem 'spree', '1.1.3'
gem 'spree_gateway', :git => 'git://github.com/spree/spree_gateway.git', :branch => '1-1-stable' # make sure to include after spree