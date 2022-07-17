# ログイン画面を表示するためのコントローラ
class HomeController < ApplicationController
  skip_before_action :strict_logged_in, only: :index

  def index
    if current_user.present?
      @meeting_schedule_anchors =
        MeetingSchedule::Anchor.where(user: current_user.id)
    end
  end

  def create
    # TODO: 仮実装として Google Calendar イベントの作成をする
    # TODO: 仮実装を終えたら 適切なコントローラに処理を移設する
  end
end
