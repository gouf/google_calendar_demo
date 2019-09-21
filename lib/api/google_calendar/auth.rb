# frozen_string_literal: true

require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

class GoogleCalendar
  class Auth
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    TOKEN_PATH = File.join(__dir__, 'token.yaml')
    APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'
    CREDENTIALS_PATH = File.join(__dir__, 'credentials.json')
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_EVENTS
    USER_ID = 'default'

    class << self
      def authorize
        authorizer =
          Google::Auth::UserAuthorizer.new(
            Google::Auth::ClientId.from_file(CREDENTIALS_PATH),
            SCOPE,
            Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
          )

        credentials = authorizer.get_credentials('default')

        if credentials.nil?
          url = authorizer.get_authorization_url(base_url: OOB_URI)

          puts 'Open the following URL in the browser and enter the ' \
            "resulting code after authorization:\n" + url

          code = gets
          credentials =
            authorizer.get_and_store_credentials_from_code(
              user_id: USER_ID,
              code: code,
              base_url: OOB_URI
            )
        end

        credentials
      end
    end
  end
end
