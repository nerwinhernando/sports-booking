FactoryBot.define do
  factory :feature_group do
    account { nil }
    feature { nil }
    group_name { "MyString" }
    enabled { false }
  end
end
