class ChangeColumnNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:activities, :user_id, true)
    change_column_null(:activities, :container_id, true)
  end
end
