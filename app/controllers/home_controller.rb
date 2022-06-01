class HomeController < ApplicationController
  skip_before_action :strict_logged_in, only: :index

  def index
  end
end
