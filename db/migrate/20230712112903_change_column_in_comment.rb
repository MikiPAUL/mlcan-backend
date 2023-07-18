class ChangeColumnInComment < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :container_references
  end
end
