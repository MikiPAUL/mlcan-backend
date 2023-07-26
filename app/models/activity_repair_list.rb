class ActivityRepairList < ApplicationRecord
    belongs_to :activity
    belongs_to :repair_list
    has_many :repair_list_attachments
end
