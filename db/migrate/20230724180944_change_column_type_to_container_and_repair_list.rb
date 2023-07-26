class ChangeColumnTypeToContainerAndRepairList < ActiveRecord::Migration[7.0]
  def change
    change_column :containers, :container_number, :string
    change_column :repair_lists, :repair_number, :string
  end
end
