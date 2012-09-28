class Spree::Users::UserProduct < ActiveRecord::Base
  attr_accessible :create_date, :product_id, :user_id
end
