# 面談候補日を作成する
class MeetingScheduleCandidateController < ApplicationController
  # * Google カレンダーにイベントを登録する
  # * レコードにイベントを登録する (MeetingScheduleCandidate)
  # (レコードにイベントを登録することで Google Calendar 側の ID の保持・管理ができる)
  # (カレンダー情報の更新削除ができる)
  def create
    EventCreator.create!(
      user_id: current_user.id,
      schedule_candidates_params: schedule_candidates_params,
      google_calendar_client: google_calendar_client
    )

    redirect_to root_path
  rescue Google::Apis::AuthorizationError
    log_out
  end

  private

  def schedule_candidates_params
    # 複数のレコードを処理するため、配列として扱う
    params.require('[meeting_schedule_candidate]')
          .map { _1.permit(:date, :description) }
  end


  def google_calendar_client
    ::GoogleCalendar.new(
      ::GoogleCalendar::Auth.authorize(session[:access_token])
    )
  end
end
