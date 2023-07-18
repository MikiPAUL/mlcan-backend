class ChangeForeignKeyInMercRepairTypes < ActiveRecord::Migration[7.0]
  def change
    rename_column :merc_repair_types, :container_id, :repair_list_id
  end
end
