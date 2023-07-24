FactoryBot.define do
    factory :activity do
        name { Faker::Name.name }
        container
        user
    end
end
