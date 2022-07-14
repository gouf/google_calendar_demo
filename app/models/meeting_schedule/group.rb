# == Schema Information
#
# Table name: meeting_schedule_groups
#
#  id                            :integer          not null, primary key
#  meeting_schedule_anchor_id    :integer          not null
#  meeting_schedule_candidate_id :integer          not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

# 面談候補日をまとめる中間テーブル
class MeetingSchedule::Group < ApplicationRecord
  belongs_to :meeting_schedule_anchor, class_name: 'MeetingSchedule::Anchor'
  belongs_to :meeting_schedule_candidate,
             class_name: 'MeetingSchedule::Candidate',
             dependent: :destroy
end
