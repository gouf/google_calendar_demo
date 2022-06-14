class AddDateToMeetingScheduleCandidates < ActiveRecord::Migration[7.0]
  def change
    add_column :meeting_schedule_candidates, :date, :datetime
  end
end
