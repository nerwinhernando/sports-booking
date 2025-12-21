FactoryBot.define do
  factory :pricing_rule do
    account { nil }
    venue { nil }
    day_type { "MyString" }
    start_time { "2025-12-22 07:21:28" }
    end_time { "2025-12-22 07:21:28" }
    price_per_hour_cents { 1 }
    active { false }
  end
end
