class ActivitySerializer < ActiveModel::Serializer
  attributes :activity_id, :activity, :activity_date, :activity_status

  def activity_id
    object.id
  end

  def activity 
    object.activity_type
  end

  def activity_date
    object.created_at.to_date
  end

  def activity_status
    object.status
  end
end
