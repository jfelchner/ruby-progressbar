require 'spec_helper'

class TimeMockedWithTimecop
  def self.now; end
  def self.now_without_mock_time; end
end

class TimeMockedWithDelorean
  def self.now; end
  def self.now_without_delorean; end
end

class TimeMockedWithActiveSupport
  def self.now; end
  def self.__simple_stub__now; end
end

class UnmockedTime
  def self.now; end
end

class     ProgressBar
describe  Time do
  # To test unmocked method selection for real, we have to clear the memoized
  # variable. But this breaks other examples, because now the wrong method is
  # being memoized. So we restore the previos method in +after+ hook
  before do
    @old_unmocked_time_method = Time.instance_variable_get(:@unmocked_time_method)
    Time.instance_variable_set(:@unmocked_time_method, nil)
  end

  after do
    Time.instance_variable_set(:@unmocked_time_method, @old_unmocked_time_method)
  end

  it 'when Time is being mocked by Timecop retrieves the unmocked Timecop time' do
    expect(TimeMockedWithTimecop).to receive(:now_without_mock_time).once

    Time.now(TimeMockedWithTimecop)
  end

  it 'when Time is being mocked by Delorean retrieves the unmocked Delorean time' do
    expect(TimeMockedWithDelorean).to receive(:now_without_delorean).once

    Time.now(TimeMockedWithDelorean)
  end

  it 'when Time is being mocked by ActiveSupport retrieves the unmocked time' do
    expect(TimeMockedWithActiveSupport).to receive(:__simple_stub__now).once

    Time.now(TimeMockedWithActiveSupport)
  end

  it 'when Time is not being mocked will return the actual time' do
    expect(UnmockedTime).to receive(:now).once

    Time.now(UnmockedTime)
  end
end
end
