class ContainerSerializer < ActiveModel::Serializer
  has_many :activity
  attributes :container_number, :yard, :customer, :owner_name

  def container_number
    object.id
  end

  def yard
    object.yard_name
  end

  def customer
    object.customer_name
  end

  def owner_name
    object.container_owner_name
  end
end
