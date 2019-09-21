# frozen_string_literal: true
require 'date'
require File.join(__dir__, 'config', 'load_database_and_models')

puts '面談候補日を入力してください'
puts '* 日付は yyyy/mm/dd 形式'
puts '* 「,」区切りで3つ入力'

candidates = gets.chomp.split(',')

# TODO: スケジュール候補の作成処理を書く
schedule = Schedule.create

puts ''
puts '面談の開始時刻を入力してください'
puts '* hh:mm 形式'
event_start_time = "#{gets.chomp}:00"

puts ''
puts '面談場所の住所を入力してください'
event_place = gets.chomp

puts ''
puts 'スケジュール内容の詳細 (会社名や面談のビル名・階数など) を入力してください'
puts 'EOF で入力終了'

event_description = []
until (input = gets.chomp).eql?('EOF') do
  event_description << input
end

schedule.create_candidates(
  candidates.map { |date| DateTime.parse("#{date} #{event_start_time}+09:00") },
  description: event_description.join("\n"),
  place: event_place
)
