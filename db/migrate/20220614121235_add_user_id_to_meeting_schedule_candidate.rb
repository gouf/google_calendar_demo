class AddUserIdToMeetingScheduleCandidate < ActiveRecord::Migration[7.0]
  def change
    add_reference :meeting_schedule_candidates, :user
  end
end
