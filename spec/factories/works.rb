FactoryGirl.define do
  factory :work do
    ident Faker::Code.isbn
    title Faker::Book.title
    subtitle "A #{ Faker::Book.genre }"
    description Faker::Hipster.paragraph
  end
end
