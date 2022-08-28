# 面談候補日群のレコードを操作する
class MeetingScheduleAnchorController < ApplicationController
  # 面談候補日群から (確定しなかったので) 予定を削除する
  # NOTE: Candidate レコードと一緒に Google Calendar イベントも削除したいので、レコード削除の順序を考慮して削除している
  # FIXME: anchor.meeting_schedule_candidates.destroy_all で削除可能にする
  def destroy
    ActiveRecord::Base.transaction do
      anchor = MeetingSchedule::Anchor.find(params[:id])
      candidates = anchor.meeting_schedule_candidates.to_a
      groups = anchor.meeting_schedule_groups
      calendar = google_calendar_client

      groups.destroy_all

      candidates.each do |candidate|
        calendar.delete_event(event_id: candidate.google_calendar_id)

        candidate.destroy!
      end

      anchor.destroy!
    end

    redirect_to root_path
  end

  private

  def google_calendar_client
    ::GoogleCalendar.new(
      ::GoogleCalendar::Auth.authorize(session[:access_token])
    )
  end
end
