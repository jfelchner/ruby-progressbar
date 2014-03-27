require 'rspectacular'

class TimeMockedWithTimecop
  def self.now; end
  def self.now_without_mock_time; end
end

class TimeMockedWithDelorean
  def self.now; end
  def self.now_without_delorean; end
end

class UnmockedTime
  def self.now; end
end

describe ProgressBar::Time do
  describe '#now' do
    context 'when Time is being mocked by Timecop' do
      subject { ProgressBar::Time.now ::TimeMockedWithTimecop }

      it 'retrieves the unmocked Timecop time' do
        allow(::TimeMockedWithTimecop).to receive(:now_without_mock_time).once

        subject
      end
    end

    context 'when Time is being mocked by Delorean' do
      subject { ProgressBar::Time.now ::TimeMockedWithDelorean }

      it 'retrieves the unmocked Delorean time' do
        allow(::TimeMockedWithDelorean).to receive(:now_without_delorean).once

        subject
      end
    end

    context 'when Time is not being mocked' do
      subject { ProgressBar::Time.now ::UnmockedTime }

      it 'will return the actual time' do
        allow(::UnmockedTime).to receive(:now).once

        subject
      end
    end
  end
end
