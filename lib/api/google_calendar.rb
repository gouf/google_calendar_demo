# frozen_string_literal: true

require 'google/apis/calendar_v3'
require 'date'
require 'active_support'
require 'active_support/core_ext'

require File.join(__dir__, 'google_calendar', 'auth')

# Google Calendar 公式ドキュメントの Quickstart で書かれていたコードを
# 参考にクラスでラッピングした
#
# カレンダーイベントの作成・更新・削除ができる
class GoogleCalendar
  def initialize(client)
    @calendar = client
  end

  # params:
  #   * summary         (optional)
  #   * location        (optional)
  #   * description     (optional)
  #   * start_date_time (required)
  def register_event(params)
    # 14:00 が渡されるのを期待
    # (固定解除は今後の実装次第)
    start_date_time = params.fetch(:start_date_time)

    # 固定値として 14:00〜17:00 に設定したいので
    # 「3時間後」に時刻を再設定
    end_date_time =
      start_date_time.advance(
        hours: 3
      )

    event =
      ::Google::Apis::CalendarV3::Event.new(
        summary: params.fetch(:summary, '(面談予定)'),
        location: params.fetch(:location, ''),
        description: params.fetch(:description, ''),
        start: {
          date_time: start_date_time.strftime("%Y-%m-%dT%H:%M:%S%:z"),
          time_zone: 'Asia/Tokyo'
        },
        end: {
          date_time: end_date_time.strftime("%Y-%m-%dT%H:%M:%S%:z"),
          time_zone: 'Asia/Tokyo'
        }
      )

    @calendar.insert_event('primary', event)
  end

  def delete_event(calendar_id: 'primary', event_id:)
    @calendar.delete_event(
      calendar_id,
      event_id,
      send_notifications: false,
      send_updates: 'none'
    )
  end

  def update_event(calendar_id: 'primary', event_id:, description:)
    event = @calendar.get_event(calendar_id, event_id)
    event.description = description

    @calendar.update_event(
      calendar_id,
      event.id,
      event,
      send_notifications: false,
      send_updates: 'none'
    )
  end

  alias :insert_event :register_event
end
