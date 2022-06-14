class AddMeetingScheduleCandidateIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :meeting_schedule_candidate
  end
end
