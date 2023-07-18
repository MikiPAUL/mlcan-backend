class Customer < ApplicationRecord
    has_many :containers
    has_many :activity
    enum status: {active: 0, inactive: 1}
    enum repair_list: {non_maersk: 0, merc: 1}
end
