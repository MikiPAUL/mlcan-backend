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
    @object.non_maersk_repair&.hours
  end
    
  def non_maersk_mat_cost
    @object.non_maersk_repair&.material_cost
  end

  def merc_hours_unit
    @object.merc_repair_type&.hours_per_cost
  end
    
  def merc_cost_unit
    @object.merc_repair_type&.unit_max_cost
  end

end
