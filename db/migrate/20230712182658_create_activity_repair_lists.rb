class CreateActivityRepairLists < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_repair_lists do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :repair_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
