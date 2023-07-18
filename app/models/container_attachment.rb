class ContainerAttachment < ApplicationRecord
  belongs_to :container
  has_one_attached :photo

  enum photo_type: {door: 0, left_side: 1, right_side: 2, interior_side: 3, under_side: 4, roof: 5, csc_plate: 6}
end
