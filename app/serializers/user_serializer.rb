class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone_number, :status, :role

  def id
    customer_id = object.id
    len = 5 - customer_id.to_s.length
    "A" + ("0" * len) + object.id.to_s
  end
end

