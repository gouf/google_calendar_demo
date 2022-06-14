require 'google/api_client/client_secrets'

class HomeController < ApplicationController
  skip_before_action :strict_logged_in, only: :index
  before_action :events, only: :index

  def index
  end

  def create
    # TODO: 仮実装として Google Calendar イベントの作成をする
  end

  private

  # NOTE: 仮実装
  # OAuth2 認証を経て得たアクセストークンを用いて、カレンダー イベントのリストを取得
  # FIXME: refactor; lib/**/*.rb にコードを移動・メソッド分割する
  # NOTE: refresh token 関連の実装が無い
  # Ref: https://readysteadycode.com/howto-access-the-google-calendar-api-with-ruby
  def events
    return if session[:access_token].blank?

    client = Signet::OAuth2::Client.new(access_token: session[:access_token])

    Google::Apis::ClientOptions.default.application_name = 'Schedule Candidate'
    # Google::Apis::ClientOptions.default.application_version = '1.0.0'
    # client_secrets = Google::APIClient::ClientSecrets.load

    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = client

    @events = calendar.list_events('primary')
  rescue Google::Apis::AuthorizationError
    @events = []
    log_out
  end
end
