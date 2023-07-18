class CreateRepairLists < ActiveRecord::Migration[7.0]
  def change
    create_table :repair_lists do |t|
      t.string :container_repair_area
      t.string :container_damaged_area
      t.integer :repair_type, default: 0

      t.timestamps
    end
  end
end
