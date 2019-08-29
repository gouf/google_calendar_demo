# frozen_string_literal: true

describe GoogleCalendar do
  def register_event
    @calendar.register_event(
      start_date_time: DateTime.new(2019, 8, 29, 14, 0, 0, '+09:00'),
      summary: 'イベント作成のテスト',
      location: 'Yokohama Sta.',
      description: 'イベント作成のテストの内容記述箇所'
    )
  end

  before do
    @calendar = GoogleCalendar.new
  end

  context '#register_event' do
    it 'can create an event' do
      VCR.use_cassette('google_calendar/create') do
        response = register_event

        expect(response).to respond_to(:id)
      end
    end
  end

  context '#delete_event' do
    it 'can delete an event' do
      VCR.use_cassette('google_calendar/create') do
        response = register_event

        VCR.use_cassette('google_calendar/delete') do
          deletion_response = @calendar.delete_event(event_id: response.id)

          expect(deletion_response).to be_empty
        end
      end
    end
  end
end
