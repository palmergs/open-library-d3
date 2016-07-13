FactoryGirl.define do
  factory :token do
    token_type "Work"
    category 1
    token Faker::Lorem.word
    year 1980
    count 1
  end
end
