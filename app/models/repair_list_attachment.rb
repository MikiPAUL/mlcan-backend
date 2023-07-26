class RepairListAttachment < ApplicationRecord
  belongs_to :activity_repair_list
  has_one_attached :photo

  enum photo_type: {damaged_area: 0, repaired_area: 1}
end
