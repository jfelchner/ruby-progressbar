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

class    ProgressBar
describe Time do
  it 'when Time is being mocked by Timecop retrieves the unmocked Timecop time' do
    allow(TimeMockedWithTimecop).to receive(:now_without_mock_time)

    Time.new(TimeMockedWithTimecop).now

    expect(TimeMockedWithTimecop).to have_received(:now_without_mock_time).once
  end

  it 'when Time is being mocked by Delorean retrieves the unmocked Delorean time' do
    allow(TimeMockedWithDelorean).to receive(:now_without_delorean)

    Time.new(TimeMockedWithDelorean).now

    expect(TimeMockedWithDelorean).to have_received(:now_without_delorean).once
  end

  it 'when Time is being mocked by ActiveSupport retrieves the unmocked time' do
    allow(TimeMockedWithActiveSupport).to receive(:__simple_stub__now)

    Time.new(TimeMockedWithActiveSupport).now

    expect(TimeMockedWithActiveSupport).to have_received(:__simple_stub__now).once
  end

  it 'when Time is not being mocked will return the actual time' do
    allow(UnmockedTime).to receive(:now)

    Time.new(UnmockedTime).now

    expect(UnmockedTime).to have_received(:now).once
  end
end
end
