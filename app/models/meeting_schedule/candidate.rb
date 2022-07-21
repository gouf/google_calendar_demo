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
# FIXME: Google Calendar API と密になりすぎているので、もうすこしマシな実装にする
# MEMO: create とか destroy 時に返ってきた値を利用してとか、モデルに持たせた attributes を、モデルの外部で Google Calendar API を利用したい
# モデルはレコードの管理責任だけ持たせたい
class MeetingSchedule::Candidate < ApplicationRecord
  attr_accessor :access_token # Google Calendar API の client 初期化に使用
  attr_accessor :summary # Google Calendar API で作るイベントのタイトル

  has_many :meeting_schedule_groups,
           class_name: 'MeetingSchedule::Group',
           foreign_key: 'meeting_schedule_candidate_id'

  before_create :create_google_calendar_event
  before_destroy :destroy_google_calendar_event

  # レコード新規作成時に Google Calendar にもイベントを登録する
  def create_google_calendar_event
    calendar = google_calendar_client

    raise RuntimeError, 'date cannot be nil.' if self.date.blank?

    self.date = self.date.change(zone: 'Asia/Tokyo')
    start_date_time = date

    result =
      calendar.register_event({
        summary: summary.blank? ? '(面談予定)' : summary,
        description: description,
        start_date_time: start_date_time
      })

    self.google_calendar_id = result.id
  end

  # レコード削除時に Google Calendar イベントも併せて削除する
  def destroy_google_calendar_event
    calendar = google_calendar_client

    result = calendar.delete_event(event_id: google_calendar_id)
  end

  # OAuth2 認証を経て得たアクセストークンを用いて、Google Calendar イベントを操作するクライアントを生成
  # NOTE: いまは refresh token 関連の仕様を利用するための実装ができてない
  # Ref: https://readysteadycode.com/howto-access-the-google-calendar-api-with-ruby
  def google_calendar_client
    raise RuntimeError, 'A required access token has not been present. Maybe you does not set yet?' if access_token.blank?

    ::GoogleCalendar.new(
      ::GoogleCalendar::Auth.authorize(access_token)
    )
  end
end