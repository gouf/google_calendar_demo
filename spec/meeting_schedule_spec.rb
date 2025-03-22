# frozen_string_literal: true

describe MeetingSchedule do
  context 'creating schedule candidates under MeetingSchedule' do
    let(:date) { DateTime.new(2019, 10, 1, 14, 0, 0, '+09:00') }

    let(:meeting_schedule) { build(:meeting_schedule) }

    let(:candidate_count) { 3 }

    before do
      meeting_schedule.save!
      VCR.use_cassette('schedule') do
        candidate_count.times do |i|
          build(
            :schedule_candidate,
            schedule_id: meeting_schedule.id,
            datetime: date.advance(days: i)
          ).save!
        end
      end
    end

    it 'refer chandidates count be 3' do
      expect(meeting_schedule.schedule_candidates.count).to eq candidate_count
    end
  end
end
