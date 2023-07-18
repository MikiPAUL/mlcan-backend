class AddVersionContainerNumberToRepairList < ActiveRecord::Migration[7.0]
  def change
    add_column :repair_lists, :version, :integer
    add_column :repair_lists, :container_number, :integer
  end
end
