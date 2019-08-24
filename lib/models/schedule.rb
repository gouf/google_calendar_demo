# frozen_string_literal: true

require 'active_record'

# スケジュール候補日郡 (ScheduleCandidate) の登録・削除と確定処理を受け持つ
class Schedule < ActiveRecord::Base
  has_many :schedule_candidates

  def create_candidates(datetime_array)
    Schedule.transaction do
      datetime_array.each do |datetime|
        ScheduleCandidate.create!(
          schedule_id: id,
          datetime: datetime
        )
      end
    end
  end
end
