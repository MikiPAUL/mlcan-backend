class AddPassswordToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :password, :string
  end
end
