require_relative 'candidate_creation'
require_relative 'candidate_decision'
require_relative 'edit_schedule'

class CalendarEventMan
  class << self
    # 日本のタイムゾーンに日時表示を変換 (eg. 2019/09/24 (火) 23:50)
    def format_time_in_jpn(datetime)
      weekday = %w[
        日
        月
        火
        水
        木
        金
        土
      ][datetime.to_date.cwday]

      datetime.in_time_zone('Asia/Tokyo')
              .strftime("%Y/%m/%d (#{weekday}) %H:%M")
    end
  end
end
