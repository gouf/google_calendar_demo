require 'tempfile'

class CalendarEventMan
  # ユーザからの入力を受けて保存した既存の候補日内容を編集する
  class EditSchedule
    def ask_all_for_need
      @schedule_id = choose_corporation_name_as_id
    end

    def proceed_task!
      schedule = ::Schedule.find(@schedule_id)
      new_description = edit_description_on_text_file(schedule.description)
      schedule.description = new_description
      schedule.save!

      update_event_description(schedule.schedule_candidates, new_description)
    end

    private

    def update_event_description(schedule_candidates, new_description)
      schedule_candidates.each do |schedule_candidate|
        schedule_candidate.update_event_description_on_google_calendar(new_description)
      end
    end

    # 候補日 (Schedule) の description をテキストエディタでユーザに編集してもらう
    def edit_description_on_text_file(description_string)
      tempfile = Tempfile.new('schedule_description')
      tempfile.write(description_string)
      tempfile.close

      system("vim #{tempfile.path}")
      ret = File.read(tempfile.path)

      tempfile.delete

      ret
    end

    def choose_corporation_name_as_id
      corporations =
        ::Schedule.all
                  .pluck(:id, :corporation_name)

      puts ''
      puts '登録済み情報を編集します'
      puts '企業名を選択してください'
      puts '* 数字を半角で入力'

      puts(corporations.map { |id, corporation_name| "#{id}: #{corporation_name}" })

      gets.chomp
    end
  end
end
