# == Schema Information
#
# Table name: meeting_schedule_anchors
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#

# Group 経由で面談候補日群を呼び出す
# Anchor -> Group -> Candidate
# 面談候補日群を留めておく
class MeetingSchedule::Anchor < ApplicationRecord
  belongs_to :user
  has_many :meeting_schedule_groups,
           class_name: 'MeetingSchedule::Group',
           foreign_key: 'meeting_schedule_anchor_id',
           dependent: :destroy
  has_many :meeting_schedule_candidates,
           through: :meeting_schedule_groups,
           class_name: 'MeetingSchedule::Candidate'

  # TODO: 候補日から確定する処理を追加する
  # TODO: 確定日を Google Calendar のイベントとして作成する
  # TODO: 候補日をレコード・Google Calendar イベント共に削除する
  # MEMO: models/meeting_schedule_candidate.rb#google_calendar_client を使いたいので module に切り出す...? (attr_accessor も一緒に切り出せる?)
end
