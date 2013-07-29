# This migration comes from spree_reviews_rating (originally 20081020220724)
class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string  :name, :location
      t.decimal :rating
      t.text :review
      t.boolean :approved, :default => false
      
      t.references :product, :user
      
      t.timestamps
    end
  end
end
