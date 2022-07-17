class DropMeetingScheduleCandidateIdFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :meeting_schedule_candidate_id
  end
end
