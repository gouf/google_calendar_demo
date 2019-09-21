# frozen_string_literal: true
require 'date'
require File.join(__dir__, 'config', 'load_database_and_models')

class CalendarEventMan
  def ask_all_for_need
    @candidates  = ask_schedule_candidates
    @start_time  = ask_event_start_time
    @location    = ask_scheduled_location
    @description = ask_event_description
  end

  def save_candidates
    raise %(Can't save schedule candidates!) unless time_to_save_schedule_candidates?

    schedule = ::Schedule.create

    schedule.create_candidates(
      @candidates.map { |date| DateTime.parse("#{date} #{@start_time}+09:00") },
      description: @description,
      location: @location
    )
  end

  def time_to_save_schedule_candidates?
    [
      @candidates,
      @start_time,
      @location,
      @description
    ].all? { |value| !value.empty? }
  end

  private

  def ask_schedule_candidates
    puts '面談候補日を入力してください'
    puts '* 日付は yyyy/mm/dd 形式'
    puts '* 「,」区切りで3つ入力'

    @candidates = gets.chomp.split(',')
  end

  def ask_event_start_time
    puts ''
    puts '面談の開始時刻を入力してください'
    puts '* hh:mm 形式'

    @start_time = "#{gets.chomp}:00"
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

event_man = CalendarEventMan.new
event_man.ask_all_for_need
event_man.save_candidates
