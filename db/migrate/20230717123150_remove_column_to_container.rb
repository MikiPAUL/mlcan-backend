class RemoveColumnToContainer < ActiveRecord::Migration[7.0]
  def change
    remove_column :containers, :comments
  end
end
