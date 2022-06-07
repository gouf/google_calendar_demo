# frozen_string_literal: true

describe Schedule do
  context 'creating schedule candidates under Schedule' do
    let(:date) { DateTime.new(2019, 10, 1, 14, 0, 0, '+09:00') }

    let(:schedule) { build(:schedule) }

    let(:candidate_count) { 3 }

    before do
      schedule.save!
      VCR.use_cassette('schedule') do
        candidate_count.times do |i|
          build(
            :schedule_candidate,
            schedule_id: schedule.id,
            datetime: date.advance(days: i)
          ).save!
        end
      end
    end

    it 'refer chandidates count be 3' do
      expect(schedule.schedule_candidates.count).to eq candidate_count
    end
  end
end
