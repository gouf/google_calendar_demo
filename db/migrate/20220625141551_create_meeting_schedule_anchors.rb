class CreateMeetingScheduleAnchors < ActiveRecord::Migration[7.0]
  def change
    create_table :meeting_schedule_anchors do |t|
      t.belongs_to :meeting_schedule_candidate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
