class CreateSpreeSweepstakesEntries < ActiveRecord::Migration
  def change
    create_table :spree_sweepstakes_entries do |t|
      t.integer :sweepstake_id
      t.string :email
      t.string :comment

      t.timestamps
    end
  end
end
