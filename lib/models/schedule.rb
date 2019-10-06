# frozen_string_literal: true

require 'active_record'

# スケジュール候補日郡 (ScheduleCandidate) の登録・削除と確定処理を受け持つ
class Schedule < ActiveRecord::Base
  has_many :schedule_candidates, dependent: :destroy

  def create_candidates(datetime_array)
    Schedule.transaction do
      # 配列のサイズは 3つ前後、少数を想定し、Google Calendar API へのリクエストを送出
      datetime_array.each do |datetime|
        event_id = insert_candidate_to_google_calendar(datetime)

        ScheduleCandidate.create!(
          schedule_id: id,
          event_id: event_id,
          datetime: datetime
        )
      end
    end
  end

  private

  def insert_candidate_to_google_calendar(datetime)
    calendar = GoogleCalendar.new
    created_event =
      calendar.insert_event(
        summary: '面談? (未定)',
        location: location,
        description: description,
        start_date_time: datetime
      )

    created_event.id
  end

  class << self
    # 面談日の確定
    def create_decision_event(candidate_id)
      deciding_candidate = ScheduleCandidate.find(candidate_id)

      # 候補日を束ねる親レコードを逆引き
      root_record =
        deciding_candidate.schedule

      calendar = GoogleCalendar.new
      calendar.insert_event(
        summary: '面談',
        location: root_record.location,
        description: root_record.description,
        start_date_time: deciding_candidate.datetime.to_datetime
      )

      # 確定後の面談予定は管理しないのでレコードを削除
      # (`dependent: :destroy` が有効なら候補日も同時に削除)
      root_record.destroy
    end
  end
end
