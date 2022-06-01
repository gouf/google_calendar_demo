class SessionsController < ApplicationController
  skip_before_action :strict_logged_in, only: :create

  def create
    user = User.find_or_create_from_auth_hash(auth_hash)

    if user.present?
      # auth_hash.credentials =>
      # #<OmniAuth::AuthHash
      #   expires=true
      #   expires_at=1653996935
      #   scope="https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid"
      #   token="ya29.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      # >
      #
      # Google Calendar API 利用に必要なトークン
      session[:access_token] = auth_hash.credentials.token

      log_in user
    end

    redirect_to root_path
  end

  def destroy
    log_out

    redirect_to root_path
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
