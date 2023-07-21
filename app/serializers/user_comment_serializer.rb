class UserCommentSerializer < ActiveModel::Serializer
  attributes :id, :name, :role

  def id
    customer_id = object.id
    len = 5 - customer_id.to_s.length
    "A" + ("0" * len) + object.id.to_s
  end
end
