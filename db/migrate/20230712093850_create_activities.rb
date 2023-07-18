class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.integer :activity_type, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :container, null: false, foreign_key: true
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
