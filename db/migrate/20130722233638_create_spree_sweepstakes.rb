class CreateSpreeSweepstakes < ActiveRecord::Migration
  def change
    create_table :spree_sweepstakes do |t|
      t.string :name
      t.string :description
      t.date :starts_at
      t.date :expires_at

      t.timestamps
    end
  end
end
