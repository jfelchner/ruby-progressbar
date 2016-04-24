require 'spec_helper'

class TimeMockedWithTimecop
  def self.now_without_mock_time; end
end

class TimeMockedWithDelorean
  def self.now_without_delorean; end
end

class TimeMockedWithActiveSupport
  def self.__simple_stub__now; end
end

class UnmockedTime
  def self.now; end
end

class           ProgressBar
RSpec.describe  Time do
  it 'when Time is being mocked by Timecop retrieves the unmocked Timecop time' do
    expect(TimeMockedWithTimecop).to receive(:now_without_mock_time).once

    Time.new(TimeMockedWithTimecop).now
  end

  it 'when Time is being mocked by Delorean retrieves the unmocked Delorean time' do
    expect(TimeMockedWithDelorean).to receive(:now_without_delorean).once

    Time.new(TimeMockedWithDelorean).now
  end

  it 'when Time is being mocked by ActiveSupport retrieves the unmocked time' do
    expect(TimeMockedWithActiveSupport).to receive(:__simple_stub__now).once

    Time.new(TimeMockedWithActiveSupport).now
  end

  it 'when Time is not being mocked will return the actual time' do
    expect(UnmockedTime).to receive(:now).once

    Time.new(UnmockedTime).now
  end
end
end
