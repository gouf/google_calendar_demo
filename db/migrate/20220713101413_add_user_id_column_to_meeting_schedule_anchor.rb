class AddUserIdColumnToMeetingScheduleAnchor < ActiveRecord::Migration[7.0]
  def change
    add_reference :meeting_schedule_anchors, :user, null: false, foreign_key: true
  end
end
