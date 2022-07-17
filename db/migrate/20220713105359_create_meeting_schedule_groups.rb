class CreateMeetingScheduleGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :meeting_schedule_groups do |t|
      t.references :meeting_schedule_anchor, null: false, foreign_key: true
      t.references :meeting_schedule_candidate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
