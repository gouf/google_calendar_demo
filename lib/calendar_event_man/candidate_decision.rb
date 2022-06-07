class CalendarEventMan
  # ユーザに訊ねて、データベース・Google Calendar に作成済みの面談候補日から面談日を確定する (候補日の削除, 確定日の決定)
  class CandidateDecision
    def ask_all_for_need
      @schedule_id           = choose_corporation_name_as_id
      @schedule_candidate_id = choose_schedule_candidate
    end

    def proceed_task!
      raise %(Can't create candidate decision) if @schedule_candidate_id.empty?

      ::Schedule.create_decision_event(@schedule_candidate_id)
    end

    private

    def choose_corporation_name_as_id
      corporations =
        ::Schedule.all
                  .pluck(:id, :corporation_name)

      puts ''
      puts '企業名を選択してください'
      puts '* 数字を半角で入力'

      puts(corporations.map { |id, corporation_name| "#{id}: #{corporation_name}" })

      gets.chomp
    end

    def choose_schedule_candidate
      puts ''
      puts '確定する面談日時を選択してください'
      puts '* 数字を半角で入力'

      schedule = ::Schedule.find(@schedule_id)

      puts schedule.corporation_name
      puts(schedule.schedule_candidates
                   .pluck(:id, :datetime)
                   .map { |id, datetime| " #{id}: #{format_time_in_jpn(datetime)}" })

      gets.chomp
    end

    # Ref: lib/calendar_event_man/calendar_event_man.rb # format_time_in_jpn
    def format_time_in_jpn(datetime)
      ::CalendarEventMan.format_time_in_jpn(datetime)
    end
  end
end
