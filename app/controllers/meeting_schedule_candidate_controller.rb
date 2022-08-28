# 面談候補日を作成する
class MeetingScheduleCandidateController < ApplicationController
  # * Google カレンダーにイベントを登録する
  # * レコードにイベントを登録する (MeetingScheduleCandidate)
  # (レコードにイベントを登録することで Google Calendar 側の ID の保持・管理ができる)
  # (カレンダー情報の更新削除ができる)
  def create
    # View から 3 レコード分送られてくるので処理
    #
    # Anchor -> Group -> Candidate の関連をもたせたレコードを作成
    # current_user.id があれば Anchor から Candidate を引っ張ってこられる
    MeetingSchedule::Candidate.transaction do
      anchor = MeetingSchedule::Anchor.new(user_id: current_user.id)
      anchor.save!

      candidate_hash = build_schedule_candidates_structure

      # 3 レコード分送られてくるので 受け入れインスタンスを生成する
      # 予定の確定など あとで使うのでレコードに保存
      # Google Calednar で予定が確認できるように API 経由で予定の作成
      candidate_hash[:days].each do |candidate_day|
        create_record_and_event(candidate_day, anchor.id, candidate_hash[:description])
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
      # description のみ抜き出す
      description: schedule_candidates_params.find(&method(:only_schedule_candidate_description))[:description],
      # 候補日のみ抜き出す
      days: schedule_candidates_params.find_all(&method(:only_schedule_candidate_date)).map { |date| date[:date] }
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

  def create_group(anchor_id, candidate_id)
    group =
      MeetingSchedule::Group.new(
        meeting_schedule_anchor_id: anchor_id,
        meeting_schedule_candidate_id: candidate_id
      )
    group.save!
  end

  def create_calendnar_event(start_date_time, description)
    calendar = google_calendar_client

    calendar.register_event({
      summary: '(面談予定)',
      description: description,
      start_date_time: start_date_time
    })
  end

  def create_record_and_event(candidate_day, anchor_id, description)
    #
    # Candidate レコード作成
    #
    candidate = MeetingSchedule::Candidate.new

    # NOTE: candidate_day は日付情報のみ保持 (eg. "2022-06-24")
    # NOTE: 作成するイベントの日時は 14:00〜17:00 に固定しているので 開始時刻は 14:00 設定
    # Ref: lib/api/google_calendar.rb #register_event
    candidate.date = "#{candidate_day} 14:00:00"
    candidate.description = description

    calendar_event = create_calendnar_event(candidate.date, candidate.description)

    candidate.google_calendar_id = calendar_event.id

    candidate.save!

    #
    # Group レコード作成
    #
    create_group(anchor_id, candidate.id)
  end

  def google_calendar_client
    ::GoogleCalendar.new(
      ::GoogleCalendar::Auth.authorize(session[:access_token])
    )
  end
end
