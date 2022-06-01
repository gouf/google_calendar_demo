class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :strict_logged_in

  def strict_logged_in
    return if current_user.present?

    redirect_to root_path
  end
end
