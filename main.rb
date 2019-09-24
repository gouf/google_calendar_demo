# frozen_string_literal: true
require 'date'
require File.join(__dir__, 'config', 'load_database_and_models')
require File.join(__dir__, 'lib', 'calendar_event_man', 'calendar_event_man')

puts '面談日の候補に対する操作'
puts '1: 複数候補日の作成'
puts '2: 候補日から確定'

choose = {
  '1' => :candidate_creation,
  '2' => :candidate_decision
}[gets.chomp]

event_man =
  case choose
  when :candidate_creation
    CalendarEventMan::CandidateCreation.new
  when :candidate_decision
    CalendarEventMan::CandidateDecision.new
  end

event_man.ask_all_for_need
event_man.proceed_task!
