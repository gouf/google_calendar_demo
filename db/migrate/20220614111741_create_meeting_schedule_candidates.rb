class CreateMeetingScheduleCandidates < ActiveRecord::Migration[7.0]
  def change
    create_table :meeting_schedule_candidates do |t|
      t.string :google_calendar_id
      t.text :description
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
