FactoryBot.define do
    factory :container do
        yard_name { Faker::Name.first_name }
        container_number { Faker::IDNumber.chilean_id }
        customer_name { Faker::Name.first_name }
        container_owner_name { Faker::Name.first_name }
        submitter_initials { Faker::Name.initials }
        container_length { Faker::Number.decimal }
        container_height { Faker::Number.decimal }
        container_type  { Faker::Name.name }
        container_manufacture_year { Faker::Vehicle.year }
        location { Faker::Games::WarhammerFantasy.location }
        customer
    end
end