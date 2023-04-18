class RemoveMeetinngScheduleAnchor < ActiveRecord::Migration[7.0]
  def change
    drop_table :meeting_schedule_anchors
  end
end
