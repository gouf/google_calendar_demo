# frozen_string_literal: true

require 'google/apis/calendar_v3'
require 'googleauth'
require 'google/api_client/client_secrets'


class GoogleCalendar
  class Auth
    APPLICATION_NAME = 'Schedule Candidate'

    class << self
      # access_token で認証し、Google Calendar client を返す
      def authorize(access_token)
        oauth2_client = ::Signet::OAuth2::Client.new(access_token: access_token)

        ::Google::Apis::ClientOptions.default.application_name = APPLICATION_NAME
        # Google::Apis::ClientOptions.default.application_version = '1.0.0'

        calendar = ::Google::Apis::CalendarV3::CalendarService.new
        calendar.authorization = oauth2_client

        calendar
      end
    end
  end
end
