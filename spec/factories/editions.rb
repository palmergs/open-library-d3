FactoryGirl.define do
  factory :edition do
    ident { Faker::Code.isbn }
    title { Faker::Book.title }
    subtitle { Faker::Book.genre }
  end
end
