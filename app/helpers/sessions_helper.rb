module SessionsHelper
  def current_user
    return if session[:user_id].blank?

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_in(user, access_token)
    session[:user_id] = user.id
    session[:access_token] = access_token
  end

  def log_out
    session.delete(:user_id)
    session.delete(:access_token)

    @current_user = nil
  end
end
