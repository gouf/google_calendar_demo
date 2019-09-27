class CalendarEventMan
  # 面談候補日作成に必要な情報をユーザに訊ねて Google Calendar に候補日を作成する
  class CandidateCreation
    def ask_all_for_need
      @corporation_name = ask_corporation_name
      @candidates       = ask_schedule_candidates
      @start_time       = ask_event_start_time
      @location         = ask_scheduled_location
      @description      = ask_event_description
    end

    def proceed_task!
      raise %(Can't save schedule candidates!) unless can_proceed?

      schedule = ::Schedule.create(corporation_name: @corporation_name)

      schedule.create_candidates(
        @candidates.map { |date| DateTime.parse("#{date} #{@start_time}+09:00") },
        description: "#{@corporation_name}\n#{@description}",
        location: @location
      )
    end

    private

    def can_proceed?
      [
        @corporation_name,
        @candidates,
        @start_time,
        @location,
        @description
      ].all? { |value| !value.empty? }
    end

    def ask_corporation_name
      puts ''
      puts '面談 企業名を入力してください'
      gets.chomp
    end

    # 一般に3つ候補日を挙げるので3つを指定。それ以上でも可。制限してない
    def ask_schedule_candidates
      puts ''
      puts '面談候補日を入力してください'
      puts '* 日付は yyyy/mm/dd 形式'
      puts '* 「,」区切りで3つ入力'

      gets.chomp.split(',')
    end

    # 実際にイベントを作成するときに「50分後」固定指定しているので、終了時刻は訊かない
    # Ref: lib/api/google_calendar/google_calendar.rb # register_event
    def ask_event_start_time
      puts ''
      puts '面談の開始時刻を入力してください'
      puts '* hh:mm 形式'

      # 別の処理からの入力で得られた日付情報と結合するのに使う
      "#{gets.chomp}:00" # hh:mm:ss
    end

    def ask_scheduled_location
      puts ''
      puts '面談場所の住所を入力してください'

      gets.chomp
    end

    def ask_event_description
      puts ''
      puts 'スケジュール内容の詳細 (会社名や面談のビル名・階数など) を入力してください'
      puts 'EOF で入力終了'

      event_description = []
      until (input = gets.chomp).eql?('EOF') do
        event_description << input
      end

      event_description.join("\n")
    end
  end
end
