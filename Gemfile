source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

group :production do
  platforms :ruby do # linux
    gem 'unicorn'
  end
  gem 'dalli'
  gem 'newrelic_rpm'
  gem 'spree_heroku', :git => 'git://github.com/joneslee85/spree-heroku.git', :branch => '1-0-stable'
end

group :development do
  gem 'sqlite3'
  gem 'rspec-rails', '2.11.0'
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

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSONgit

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
gem 'jquery-rails', '2.1.4'
gem 'spree', '1.3.1'
gem 'spree', '1.3.1'
gem 'spree_fancy', :branch => "customize_to_uniqteas", :git => 'git://github.com/mcaraway/spree_fancy.git'
gem 'spree_auth_devise', :branch => "1-3-stable", :git => 'git://github.com/spree/spree_auth_devise'
gem 'spree_active_shipping', :branch => "1-3-stable", :git => "git://github.com/spree/spree_active_shipping"
gem 'active_shipping', :git => "git://github.com/Shopify/active_shipping"
gem "spree_paypal_express", :branch => "1-3-stable", :git => "git://github.com/spree/spree_paypal_express.git"
gem 'spree_gateway', :branch => "1-3-stable", :git => 'git://github.com/spree/spree_gateway.git' # make sure to include after spree
gem 'spree_volume_pricing', :branch => "1-3-stable", :git => 'git://github.com/spree/spree_volume_pricing.git'
gem "spree_social_products", :branch => "1-2-stable", :git => "git://github.com/spree/spree_social_products.git"
gem 'spree_address_book', :git => "git://github.com/romul/spree_address_book.git"
# gem 'spree_print_invoice', :branch => "1-1-stable", :git => 'git://github.com/spree/spree_print_invoice.git'
gem 'spree_contact_us', :branch => "1-2-stable", :git => 'git://github.com/jdutil/spree_contact_us'
gem 'spree_variant_options', '0.4.1'
gem 'datashift'
gem 'datashift_spree'