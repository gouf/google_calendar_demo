class DropCompanyIdFromMeetingScheduleCandidate < ActiveRecord::Migration[7.0]
  def change
    remove_column :meeting_schedule_candidates, :company_id
  end
end
