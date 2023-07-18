class AddColumnsToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :repair_list, :integer, default: 0
    add_column :customers, :status, :integer, default: 0
  end
end
