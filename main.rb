# frozen_string_literal: true
require 'date'
require File.join(__dir__, 'config', 'load_database_and_models')
require File.join(__dir__, 'lib', 'calendar_event_man', 'calendar_event_man')

#
# Google Calendar に面談候補日を作成
# 候補日をデータベースで管理し、確定時に候補予定日をカレンダーから削除・確定する
#

puts '面談日の候補に対する操作'
puts '1: 複数候補日の作成'
puts '2: 候補日から確定'
puts '3: 既存の候補日情報 (詳細情報) を編集'

choose = {
  '1' => :candidate_creation,
  '2' => :candidate_decision,
  '3' => :edit_schedule
}[gets.chomp]

event_man =
  case choose
  when :candidate_creation
    CalendarEventMan::CandidateCreation.new
  when :candidate_decision
    CalendarEventMan::CandidateDecision.new
  when :edit_schedule
    CalendarEventMan::EditSchedule.new
  end

event_man.ask_all_for_need
event_man.proceed_task!
