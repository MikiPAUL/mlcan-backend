class LogSerializer < ActiveModel::Serializer
  attributes :log_id, :activity_id, :old_status, :new_status

  def log_id
    object.id
  end
end
