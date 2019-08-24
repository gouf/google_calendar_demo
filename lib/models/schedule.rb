# frozen_string_literal: true

require 'active_record'

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
