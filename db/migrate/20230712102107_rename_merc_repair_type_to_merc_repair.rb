class RenameMercRepairTypeToMercRepair < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      # dir.up do
      #   rename_table :merc_repair_types, :merc_repairs
      # end
      dir.down do
        rename_table :merc_repairs, :merc_repair_types
      end
    end
  end
end
