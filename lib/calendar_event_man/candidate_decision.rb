class CalendarEventMan
  # ユーザに訊ねて、データベース・Google Calendar に作成済みの面談候補日から面談日を確定する (候補日の削除, 確定日の決定)
  class CandidateDecision
    def ask_all_for_need
      @schedule_id           = choose_corporation_name
      @schedule_candidate_id = choose_schedule_candidate
    end

    def proceed_task!
      raise %(Can't create candidate decision) if @schedule_candidate_id.empty?

      ::Schedule.create_decision_event(@schedule_candidate_id)
    end

    private

    def choose_corporation_name
      corporations =
        ::Schedule.all
                  .pluck(:id, :corporation_name)

      puts ''
      puts '企業名を選択してください'
      puts '* 数字を半角で入力'

      puts corporations.map { |id, corporation_name| "#{id}: #{corporation_name}" }

      gets.chomp
    end

    def choose_schedule_candidate
      puts ''
      puts '確定する面談日時を選択してください'

      corporations =
        ::Schedule.all
                  .pluck(:id, :corporation_name)

      corporations.map do |id, corporation_name|
        puts corporation_name
        puts ::Schedule.find(id)
                       .schedule_candidates
                       .pluck(:id, :datetime)
                       .map { |id, datetime| " #{id}: #{format_time_in_jpn(datetime)}" }
      end

      gets.chomp
    end

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
