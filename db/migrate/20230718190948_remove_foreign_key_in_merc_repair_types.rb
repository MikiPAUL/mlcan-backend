class RemoveForeignKeyInMercRepairTypes < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :merc_repair_types, :containers
    add_foreign_key :merc_repair_types, :repair_lists
  end
end
