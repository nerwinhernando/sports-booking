FactoryBot.define do
  factory :booking do
    account { nil }
    user { nil }
    court { nil }
    schedule { nil }
    start_time { "2025-12-22 07:21:01" }
    end_time { "2025-12-22 07:21:01" }
    amount_cents { 1 }
    status { "MyString" }
    payment_method { "MyString" }
    payment_reference { "MyString" }
    notes { "MyText" }
  end
end
