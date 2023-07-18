class CreateNonMaerskRepairs < ActiveRecord::Migration[7.0]
  def change
    create_table :non_maersk_repairs do |t|
      t.integer :hours
      t.float :material_cost
      t.string :container_section
      t.string :damaged_area
      t.integer :repair_type
      t.string :description
      t.string :comp
      t.string :dam
      t.string :rep
      t.string :component
      t.string :event
      t.string :location
      t.string :area
      t.string :area2
      t.integer :id_source
      t.references :repair_list, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
