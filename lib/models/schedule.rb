# frozen_string_literal: true

require 'active_record'

# スケジュール候補日郡 (ScheduleCandidate) の登録・削除と確定処理を受け持つ
class Schedule < ActiveRecord::Base
  has_many :schedule_candidates, dependent: :destroy

  def create_candidates(datetime_array, description:, location:)
    Schedule.transaction do
      datetime_array.each do |datetime|
        ScheduleCandidate.create!(
          schedule_id: id,
          datetime: datetime,
          description: description,
          location: location
        )
      end
    end
  end

  class << self
    # 面談日の確定
    def create_decision_event(candidate_id)
      deciding_candidate = ScheduleCandidate.find(candidate_id)

      calendar = GoogleCalendar.new
      calendar.insert_event(
        summary: '面談',
        location: deciding_candidate.location,
        description: deciding_candidate.description,
        start_date_time: deciding_candidate.datetime.to_datetime
      )

      root_record =
        ScheduleCandidate.find(candidate_id).schedule

      # 確定後の面談予定は管理しないのでレコードを削除
      root_record.destroy
    end
  end
end
