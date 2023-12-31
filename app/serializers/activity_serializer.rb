class ActivitySerializer < ActiveModel::Serializer
  attributes :activity_id, :activity, :activity_date

  def activity_id
    object.id
  end

  def activity 
    object.activity_type
  end

  def activity_date
    object.created_at.to_date
  end
end
