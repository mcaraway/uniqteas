# This migration comes from spree_reviews_rating (originally 20120323165848)
class ReviewsRatingNamespace < ActiveRecord::Migration
  def change
    rename_table :reviews, :spree_reviews
  end
end
