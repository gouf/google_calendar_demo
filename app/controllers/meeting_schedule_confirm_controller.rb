# 面談候補日群から面談日を確定する
class MeetingScheduleConfirmController < ApplicationController
  # 与えられた Candidate id をもとに、Google Calendar に確定日としてイベントを登録する
  # 選ばれた候補日から 確定日として Google Calendar イベントを作成したら、Anchor 自身, Group, Candidate 含め Anchor に紐づくデータをすべて削除する
  def create
    ActiveRecord::Base.transaction do
      anchor = MeetingSchedule::Anchor.find(params[:anchor_id])
      calendar = google_calendar_client

      confirmed_schedule =
        removing_candidates.find { |candidate| candidate.id.eql?(params[:candidate_id].to_i) }.dup
      # NOTE: 後続の行で Group を削除する都合上、その削除前に candidates を確保する。 (処理順が前後すると association による参照が不能になり空の配列が返る)
      candidates = removing_candidates

      # 外部キー制約を回避, 不要データの削除
      anchor.meeting_schedule_groups.destroy_all

      raise RuntimeError, 'Candidates size cannot be zero.' if candidates.size.zero?

      candidates.each do |candidate|
        calendar.delete_event(event_id: candidate.google_calendar_id)

        candidate.destroy!
      end

      calendar_event =
        calendar.register_event({
          summary: '面談',
          description: confirmed_schedule.description,
          start_date_time: confirmed_schedule.date
        })

      confirmed_schedule.google_calendar_id = calendar_event.id
      confirmed_schedule.save!

      anchor.destroy
    end

    redirect_to root_path
  end

  private

  def removing_candidates
    anchor = MeetingSchedule::Anchor.find(params[:anchor_id])

    anchor.meeting_schedule_candidates.to_a
  end

  def google_calendar_client
    ::GoogleCalendar.new(
      ::GoogleCalendar::Auth.authorize(session[:access_token])
    )
  end
end
