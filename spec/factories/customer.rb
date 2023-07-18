FactoryBot.define do
    factory :customer do
        name { Faker::Name.name }
        email { Faker::Internet.email }
        owner_name { Faker::Name.name }
        billing_name { Faker::Name.name }
        hourly_rate { Faker::Number.decimal }
        gst { Faker::Number.decimal }
        pst { Faker::Number.decimal }
        city { Faker::JapaneseMedia::FmaBrotherhood.city }
        address { Faker::Address.full_address }
        province { Faker::PhoneNumber.area_code }
    end
end
