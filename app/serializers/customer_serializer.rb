class CustomerSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner_name, :email, :hourly_rate, :status

  def id
    customer_id = object.id
    len = 5 - customer_id.to_s.length
    "A" + ("0" * len) + object.id.to_s
  end

  def hourly_rate
    object.hourly_rate.to_s + "$"
  end
end
