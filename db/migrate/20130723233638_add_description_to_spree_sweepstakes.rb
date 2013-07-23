class AddDescriptionToSpreeSweepstakes < ActiveRecord::Migration
  def change
    add_column :spree_sweepstakes, :description, :string
  end
end
