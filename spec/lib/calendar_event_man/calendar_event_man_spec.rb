describe CalendarEventMan do
  context '#format_time_in_jpn' do
    let(:datetime) { DateTime.new(2019, 10, 15, 3, 0, 0, '+9:00') }

    subject { CalendarEventMan.format_time_in_jpn(datetime) }

    it { is_expected.to eq '2019/10/15 (火) 03:00' }
  end
end
