class ContainerActivityRepairListSerializer < ActiveModel::Serializer
  attributes :id, :repair_number, :repair_area, :damaged_area, :type, :quantity, :location,
              :labour_cost, :material_cost

  def repair_id 
    @object.repair_number
  end

  def repair_area
    @object.container_repair_area
  end

  def damaged_area
    @object.container_damaged_area
  end

  def type
    @object.repair_type
  end
  
  def quantity
    @object.merc_repair_type&.units
  end
    
  def location
    @object.non_maersk_repair&.location
  end

  def labour_cost
    @object.merc_repair_type&.hours_per_cost
  end
    
  def material_cost
    @object.non_maersk_repair&.material_cost
  end

end
