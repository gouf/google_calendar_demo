# frozen_string_literal: true

require File.join(__dir__, '..', 'api', 'google_calendar', 'google_calendar')
require 'active_record'

# Schedule モデルを親とした、スケジュール候補日を管理する
class ScheduleCandidate < ActiveRecord::Base
  belongs_to :schedule

  before_create(:insert_event_to_google_calendar)

  before_destroy(:delete_event_on_google_calendar)

  private

  def insert_event_to_google_calendar
    calendar = GoogleCalendar.new
    created_event =
      calendar.insert_event(
        summary: 'テスト作成',
        location: '',
        description: 'Google Calendar API を通して予定をテスト作成',
        start_date_time: datetime
      )

    self.event_id = created_event.id
  end

  def delete_event_on_google_calendar
    calendar = GoogleCalendar.new

    calendar.delete_event(event_id: event_id)
  end
end
