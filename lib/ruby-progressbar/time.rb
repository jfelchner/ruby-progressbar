class   ProgressBar
class   Time
  def self.now(time = ::Time)
    @time = time

    @time.send unmocked_time_method
  end

  def self.unmocked_time_method
    time_mocking_library_methods.find { |method| @time.respond_to? method }
  end

  def self.time_mocking_library_methods
    %i{
      now_without_mock_time
      now_without_delorean
      now
    }
  end
end
end
