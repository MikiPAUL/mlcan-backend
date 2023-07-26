class AddCommentsColumnToActivityRepairLists < ActiveRecord::Migration[7.0]
  def change
    add_column :activity_repair_lists, :comments, :text
  end
end
