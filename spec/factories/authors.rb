FactoryGirl.define do
  factory :author do
    ident { Faker::Code.isbn }
    name { Faker::Book.author }
    description { Faker::Hipster.paragraph }
  end
end
