class CreateUserProducts < ActiveRecord::Migration
  def change
    create_table :user_products do |t|
      t.integer :user_id
      t.integer :product_id
      t.datetime :create_date

      t.timestamps
    end
  end
  
  def down
    drop table :user_products
  end
end
