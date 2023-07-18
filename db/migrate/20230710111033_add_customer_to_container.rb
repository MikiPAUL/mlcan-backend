class AddCustomerToContainer < ActiveRecord::Migration[7.0]
  def change
    add_column :containers, :customer_id, :integer
    add_foreign_key :containers, :customers
  end
end
