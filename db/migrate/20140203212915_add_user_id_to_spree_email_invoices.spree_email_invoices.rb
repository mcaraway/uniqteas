# This migration comes from spree_email_invoices (originally 20131220162936)
class AddOrderIdToSpreeEmailInvoices < ActiveRecord::Migration
  def change
    add_column :spree_email_invoices, :user_id, :integer
  end
end
