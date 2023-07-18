class AddColumnsToLog < ActiveRecord::Migration[7.0]
  def change
    add_column :logs, :old_status, :string
    add_column :logs, :new_status, :string
  end
end
