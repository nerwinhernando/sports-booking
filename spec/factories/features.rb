FactoryBot.define do
  factory :feature do
    account { nil }
    name { "MyString" }
    description { "MyText" }
    enabled { false }
    rollout_percentage { 1 }
  end
end
