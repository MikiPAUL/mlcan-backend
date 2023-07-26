class ActivityRepairListSerializer < ActiveModel::Serializer
  attributes :id, :comments
  belongs_to :repair_list, serializer: ContainerActivityRepairListSerializer
  belongs_to :activity
end
