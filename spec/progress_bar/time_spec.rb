require 'spec_helper'

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
        ::TimeMockedWithTimecop.should_receive(:now_without_mock_time).once
        ::TimeMockedWithTimecop.should_not_receive(:now)

        subject
      end
    end

    context 'when Time is being mocked by Delorean' do
      subject { ProgressBar::Time.now ::TimeMockedWithDelorean }

      it 'retrieves the unmocked Delorean time' do
        ::TimeMockedWithDelorean.should_receive(:now_without_delorean).once
        ::TimeMockedWithDelorean.should_not_receive(:now)

        subject
      end
    end

    context 'when Time is not being mocked' do
      subject { ProgressBar::Time.now ::UnmockedTime }

      it 'will return the actual time' do
        ::UnmockedTime.should_receive(:now).once

        subject
      end
    end
  end
end
