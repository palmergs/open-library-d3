FactoryGirl.define do
  factory :edition_publisher do
    edition
    name { Faker::Book.publisher }
  end
end
