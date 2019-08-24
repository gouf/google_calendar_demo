# frozen_string_literal: true

require File.join(__dir__, 'config', 'load_database_and_models')

#
# SPEC:
# 1件の面談スケジュール(未確定) からスケジュール候補日群を作成
# 作成したスケジュール候補日は Google Calendar に登録する
# 会社との連絡で面談日が確定したときに、確定処理を実行することで
# 候補日を Google Calendar 上から削除する (確定日だけが残る)
#
# 複数件の面談スケジュールとその候補日を管理できる
#

# スケジュール レコードの親を作成
schedule = Schedule.find_or_create_by(id: 1)

# ScheduleCandidate.destroy_all

schedule_candidates = [
  DateTime.new(2019, 9, 1, 14, 0, 0, '+9'),
  DateTime.new(2019, 9, 2, 14, 0, 0, '+9'),
  DateTime.new(2019, 9, 3, 14, 0, 0, '+9')
]

# スケジュール候補日を親と関連付けて作成
Schedule.transaction do
  schedule.create_candidates(schedule_candidates)
end

# pp Schedule.all
# pp ScheduleCandidate.all
pp Schedule.first.schedule_candidates # 1件の面談の候補日情報をリストアップ
# pp ScheduleCandidate.first.schedule

# TODO: 候補日3つを入力する UI の作成
# TODO: 候補日から確定日を選び取る UI の作成
# TODO: スケジュールが確定した際の候補日の削除処理 (レコード, Google Calendar API)
# TODO: スケジュール候補日作成時に「summary」「location」などのパラメータを受け取れるようにする
# TODO: スケジュール候補日削除時に Google Calendar 側の予定も削除できるよう、API 側が管理しているID をレコードとして保存できるようにする
