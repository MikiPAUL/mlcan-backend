class CreateContainers < ActiveRecord::Migration[7.0]
  def change
    create_table :containers do |t|
      t.string :yard_name
      t.integer :container_number
      t.string :customer_name
      t.string :container_owner_name
      t.string :submitter_initials
      t.float :container_length
      t.float :container_height
      t.string :container_type
      t.datetime :container_manufacture_year
      t.string :location
      t.string :comments

      t.timestamps
    end
  end
end
