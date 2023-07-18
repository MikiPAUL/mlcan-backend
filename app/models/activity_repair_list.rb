class ActivityRepairList < ApplicationRecord
    belongs_to :activity
    belongs_to :repair_list
end
