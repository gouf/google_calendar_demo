class DropMeetingScheduleCandidateColumnFromMeetingScheduleAnchor < ActiveRecord::Migration[7.0]
  def change
    remove_column :meeting_schedule_anchors, :meeting_schedule_candidate_id
  end
end
