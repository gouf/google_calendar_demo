class AddMeetingScheduleGroupIdToMeetingScheduleAnchor < ActiveRecord::Migration[7.0]
  def change
    add_reference :meeting_schedule_anchors, :meeting_schedule_group, null: false, foreign_key: true
  end
end
