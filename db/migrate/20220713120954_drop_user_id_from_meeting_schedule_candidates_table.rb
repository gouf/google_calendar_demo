class DropUserIdFromMeetingScheduleCandidatesTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :meeting_schedule_candidates, :user_id
  end
end
