class CreateRepairListAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :repair_list_attachments do |t|
      t.references :activity_repair_list, null: false, foreign_key: true
      t.integer :photo_type, default: 0

      t.timestamps
    end
  end
end
