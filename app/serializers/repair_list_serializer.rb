class RepairListSerializer < ActiveModel::Serializer
  attributes :repair_id, :repair_number, :repair_area, :damaged_area, :non_maersk_hours, :non_maersk_mat_cost,
              :merc_hours_unit, :merc_cost_unit

  def repair_id 
    @object.id
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
  
  def non_maersk_hours
    ((@object.has_attribute? :non_maersk_repair_hours) ? @object.non_maersk_repair_hours : nil)
  end
    
  def non_maersk_mat_cost
    ((@object.has_attribute? :non_maersk_repair_mat_cost) ? @object.non_maersk_repair_mat_cost : nil)
  end

  def merc_hours_unit
    ((@object.has_attribute? :merc_hours_unit) ? @object.merc_hours_unit : nil)
  end
    
  def merc_cost_unit
    ((@object.has_attribute? :merc_cost_unit) ? @object.merc_cost_unit : nil)
  end

end
