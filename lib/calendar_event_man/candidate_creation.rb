class CalendarEventMan
  # 面談候補日作成に必要な情報をユーザに訊ねて Google Calendar に候補日を作成する
  class CandidateCreation
    def ask_all_for_need
      @corporation_name = ask_corporation_name
      show_already_scheduled_event
      @candidates       = ask_schedule_candidates
      @start_time       = ask_event_start_time
      @location         = ask_scheduled_location
      @description      = ask_event_description
    end

    def proceed_task!
      raise %(Can't save schedule candidates!) unless can_proceed?

      schedule =
        ::Schedule.create!(
          corporation_name: @corporation_name,
          location: @location,
          description: "#{@corporation_name}\n#{@description}"
        )

      schedule.create_candidates(
        @candidates.map { |date| DateTime.parse("#{date} #{@start_time}+09:00") }
      )

      # 記録済みスケジュール候補をユーザに一覧表示形式で返す
      @candidates.each.with_index(1) do |candidate, i|
        puts "#{i}. #{format_time_in_jpn(DateTime.parse("#{candidate} #{@start_time}+09:00"))}"
      end
    end

    private

    def can_proceed?
      [
        @corporation_name,
        @candidates,
        @start_time,
        @location,
      ].all? { |value| !value.empty? }
    end

    def show_already_scheduled_event
      puts ''
      puts '既存スケジュール 一覧 (候補日):'
      schedule_candidates =
        ::Schedule.all
                  .map(&:schedule_candidates)
                  .flatten
      puts(
        schedule_candidates.sort
                           .map(&:datetime)
                           .map(&method(:format_time_in_jpn))
                           .map { |datetime| "* #{datetime}" }
      )
    end

    def ask_corporation_name
      puts ''
      puts '面談 企業名を入力してください (*必須)'
      gets.chomp
    end

    # 一般に3つ候補日を挙げるので3つを指定。それ以上でも可。制限してない
    def ask_schedule_candidates
      puts ''
      puts '面談候補日を入力してください (*必須)'
      puts '* 日付は yyyy/mm/dd 形式'
      puts '* 「,」区切りで3つ入力'

      gets.chomp.split(',')
    end

    # 実際にイベントを作成するときに「50分後」固定指定しているので、終了時刻は訊かない
    # Ref: lib/api/google_calendar/google_calendar.rb # register_event
    def ask_event_start_time
      puts ''
      puts '面談の開始時刻を入力してください (*必須)'
      puts '* hh:mm 形式'

      # 別の処理からの入力で得られた日付情報と結合するのに使う
      "#{gets.chomp}:00" # hh:mm:ss
    end

    def ask_scheduled_location
      puts ''
      puts '面談場所の住所を入力してください (*必須)'

      gets.chomp
    end

    def ask_event_description
      puts ''
      puts 'スケジュール内容の詳細 (会社名や面談のビル名・階数など) を入力してください'
      puts '* EOF で入力終了'

      event_description = []
      until (input = gets.chomp).eql?('EOF') do
        event_description << input
      end

      event_description.join("\n")
    end

    # Ref: lib/calendar_event_man/calendar_event_man.rb # format_time_in_jpn
    def format_time_in_jpn(datetime)
      ::CalendarEventMan.format_time_in_jpn(datetime)
    end
  end
end
