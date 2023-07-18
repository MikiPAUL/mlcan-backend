FactoryBot.define do
    factory :repair_list do
        container_repair_area { Faker::Name.name }
        container_damaged_area { Faker::Name.name }
        repair_number { Faker::Number.digit }
        version { 1 }
    end
end