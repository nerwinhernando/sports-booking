FactoryBot.define do
  factory :schedule_template do
    account { nil }
    venue { nil }
    name { "MyString" }
    day_of_week { "MyString" }
    start_time { "2025-12-22 07:21:58" }
    end_time { "2025-12-22 07:21:58" }
    slot_duration_minutes { 1 }
    price_cents { 1 }
    day_type { "MyString" }
    is_peak_hour { false }
    active { false }
  end
end
