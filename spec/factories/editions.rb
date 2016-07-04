FactoryGirl.define do
  factory :edition do
    work
    title { self.work.title }
    subtitle { self.work.subtitle }
  end
end
