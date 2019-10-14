FactoryBot.define do
  factory :schedule_candidate do
    schedule
    event_id { 'lfdekfonm04mdp36q9ajrt9rv0' } # Google Calendar Event ID
    datetime { DateTime.new(2019, 10, 1, 14, 0, 0, '+09:00') }
  end
end
