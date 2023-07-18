class CreateContainerAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :container_attachments do |t|
      t.integer :photo_type, default: 0
      t.references :container, null: false, foreign_key: true

      t.timestamps
    end
  end
end
