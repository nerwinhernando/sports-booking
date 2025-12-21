FactoryBot.define do
  factory :feature_user do
    account { nil }
    feature { nil }
    user_identifier { "MyString" }
    enabled { false }
  end
end
