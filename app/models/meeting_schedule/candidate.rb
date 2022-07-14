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
  attr_accessor :access_token # Google Calendar API の client 初期化に使用

  has_many :meeting_schedule_groups, class_name: 'MeetingSchedule::Group'

  before_create :create_google_calendar_event

  private

  # レコード新規作成時に Google Calendar にもイベントを登録する
  def create_google_calendar_event
    calendar = google_calendar_client

    raise RuntimeError, 'date cannot be nil.' if self.date.blank?

    self.date = self.date.change(zone: 'Asia/Tokyo')
    start_date_time = date

    # 固定値として 14:00〜17:00 に設定したいので
    # 「3時間後」に時刻を再設定
    end_date_time =
      start_date_time.advance(
        hours: 3
      )

    event =
      ::Google::Apis::CalendarV3::Event.new(
        summary: '(面談予定)',
        location: '',
        description: description,
        start: ::Google::Apis::CalendarV3::EventDateTime.new(
          date_time: start_date_time.strftime("%Y-%m-%dT%H:%M:%S%:z"),
          time_zone: 'Asia/Tokyo'
        ),
        end: ::Google::Apis::CalendarV3::EventDateTime.new(
          date_time: end_date_time.strftime("%Y-%m-%dT%H:%M:%S%:z"),
          time_zone: 'Asia/Tokyo'
        )
      )

    result = calendar.insert_event('primary', event)

    self.google_calendar_id = result.id
  end

  # OAuth2 認証を経て得たアクセストークンを用いて、カレンダー イベントを操作する
  # FIXME: refactor; lib/**/*.rb にコードを移動・メソッド分割する
  # NOTE: refresh token 関連の実装が無い
  # Ref: https://readysteadycode.com/howto-access-the-google-calendar-api-with-ruby
  def google_calendar_client
    client = ::Signet::OAuth2::Client.new(access_token: access_token)

    ::Google::Apis::ClientOptions.default.application_name = 'Schedule Candidate'
    # Google::Apis::ClientOptions.default.application_version = '1.0.0'
    # client_secrets = Google::APIClient::ClientSecrets.load

    calendar = ::Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = client

    calendar
  end
end
