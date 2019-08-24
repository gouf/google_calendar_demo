# frozen_string_literal: true

require File.join(__dir__, '..', 'api', 'google_calendar', 'google_calendar')
require 'active_record'

class ScheduleCandidate < ActiveRecord::Base
  belongs_to :schedule

  before_create(:insert_event_to_google_calendar)

  private

  def insert_event_to_google_calendar
    calendar = GoogleCalendar.new
    calendar.insert_event(
      summary: 'テスト作成',
      location: '',
      description: 'Google Calendar API を通して予定をテスト作成',
      start_date_time: datetime
    )
  end
end

