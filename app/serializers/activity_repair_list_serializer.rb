class ActivityRepairListSerializer < ActiveModel::Serializer
  attributes :id, :name, :activity_type, :user_id, :container_id, :status
  has_many: activity_repair_list
end
