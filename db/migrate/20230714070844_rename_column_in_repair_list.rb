class RenameColumnInRepairList < ActiveRecord::Migration[7.0]
  def change
    rename_column :repair_lists, :container_number, :repair_number
  end
end
