class CreateMercRepairTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :merc_repair_types do |t|
      t.integer :max_min_cost
      t.integer :unit_max_cost
      t.integer :hours_per_cost
      t.integer :max_pieces
      t.integer :units
      t.string :repair_mode
      t.integer :mode_number
      t.integer :repair_code
      t.string :combined
      t.string :description
      t.integer :id_source
      t.references :container, null: false, foreign_key: true

      t.timestamps
    end
  end
end
