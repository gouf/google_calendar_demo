# == Schema Information
#
# Table name: meeting_schedule_candidates
#
#  id                 :integer          not null, primary key
#  google_calendar_id :string
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  date               :datetime
#

# 面談候補日
class MeetingSchedule::Candidate < ApplicationRecord
  has_many :meeting_schedule_groups,
           class_name: 'MeetingSchedule::Group',
           foreign_key: 'meeting_schedule_candidate_id'
end
