# 面談候補日を作成する
class MeetingScheduleCandidateController < ApplicationController
  # * Google カレンダーにイベントを登録する
  # * レコードにイベントを登録する (MeetingScheduleCandidate)
  # (レコードにイベントを登録することで Google Calendar 側の ID の保持・管理ができる)
  # (カレンダー情報の更新削除ができる)
  def create
    schedule_candidate_hash = build_schedule_candidates_structure

    # View から 3 レコード分送られてくるので処理
    MeetingScheduleCandidate.transaction do
      # 3 レコード分送られてくるので 受け入れインスタンスを生成する
      schedule_candidate_hash[:days].each do |schedule_candidate_day|
        meeting_schedule_candidate = MeetingScheduleCandidate.new

        meeting_schedule_candidate.user_id = current_user.id
        # NOTE: モデルに Google Calendar API へのアクセスを任せているので、何らかの形で access_token を渡す必要がある
        meeting_schedule_candidate.access_token = session[:access_token]
        meeting_schedule_candidate.description = schedule_candidate_hash[:description]
        # NOTE: schedule_candidate_day は日付情報のみ保持 (eg. "2022-06-24")
        # NOTE: 作成するイベントの日時は 14:00〜17:00 に固定しているので 開始時刻は 14:00 設定
        meeting_schedule_candidate.date = "#{schedule_candidate_day} 14:00:00"

        meeting_schedule_candidate.save!
      end
    end

    redirect_to root_path
  rescue Google::Apis::AuthorizationError
    log_out
  end

  def destroy
    # TODO: レコードの削除
    # TODO: レコードの削除と同時に、関連付けられた Google Calendar のイベントを削除する
  end

  private

  def schedule_candidates_params
    params.require(:meeting_schedule_candidate)
          .map { |d| d.permit(:date, :description) }
  end

  # create アクションでモデルに情報を渡しやすいように Hash にまとめる
  def build_schedule_candidates_structure
    {
      description: schedule_candidates_params.find(&method(:only_schedule_candidate_description))[:description],
      days: schedule_candidates_params.find_all(&method(:only_schedule_candidate_date))
    }
  end

  # for filter method
  def only_schedule_candidate_date(schedule_candidate)
    schedule_candidate.dig(:date).present?
  end

  # for filter method
  def only_schedule_candidate_description(schedule_candidate)
    schedule_candidate.dig(:description).present?
  end
end
