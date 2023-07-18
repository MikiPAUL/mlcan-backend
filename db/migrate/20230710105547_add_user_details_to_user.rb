class AddUserDetailsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :phone_number, :string 
    add_column :users, :status, :integer, default: 0
    add_column :users, :role, :integer, default: 0
    add_column :users, :is_deleted, :boolean, default: false
  end
end
