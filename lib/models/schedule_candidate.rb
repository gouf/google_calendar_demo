# frozen_string_literal: true

require File.join(__dir__, '..', 'api', 'google_calendar', 'google_calendar')
require 'active_record'

# Schedule モデルを親とした、スケジュール候補日を管理する
class ScheduleCandidate < ActiveRecord::Base
  belongs_to :schedule

  before_destroy(:delete_event_on_google_calendar)

  private

  def delete_event_on_google_calendar
    calendar = GoogleCalendar.new

    calendar.delete_event(event_id: event_id)
  end
end
