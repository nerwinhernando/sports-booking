FactoryBot.define do
  factory :schedule_block do
    account { nil }
    court { nil }
    block_date { "2025-12-22" }
    start_time { "2025-12-22 07:22:20" }
    end_time { "2025-12-22 07:22:20" }
    reason { "MyString" }
    notes { "MyText" }
    all_day { false }
  end
end
