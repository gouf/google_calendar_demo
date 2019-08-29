# frozen_string_literal: true

require 'google/apis/calendar_v3'
require 'date'
require 'active_support'
require 'active_support/core_ext'

require File.join(__dir__, 'auth')

# Google Calendar 公式ドキュメントの Quickstart で書かれていたコードを
# 参考にクラスでラッピングした
class GoogleCalendar
  def initialize
    @calendar = ::Google::Apis::CalendarV3::CalendarService.new
    @calendar.client_options.application_name = Auth::APPLICATION_NAME
    # 認証手続きを呼び出して 認可情報を返す
    @calendar.authorization = Auth.authorize
  end

  def register_event(params)
    start_date_time = params.fetch(:start_date_time)

    # 「50分後」に時刻を再設定
    end_date_time =
      start_date_time.advance(
        minutes: 50
      )

    event =
      ::Google::Apis::CalendarV3::Event.new(
        summary: params.fetch(:summary, '面談? (未定)'),
        location: params.fetch(:location, ''),
        description: params.fetch(:description, ''),
        start: {
          date_time: start_date_time.to_s,
          time_zone: 'Asia/Tokyo'
        },
        end: {
          date_time: end_date_time.to_s,
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

  alias :insert_event :register_event
end
