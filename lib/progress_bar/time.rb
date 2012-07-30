class ProgressBar
  class Time
    def self.now(time = ::Time)
      @@time = time

      @@time.send unmocked_time_method
    end

  private
    def self.unmocked_time_method
      @@time.respond_to?(:now_without_mock_time) ? :now_without_mock_time : :now
    end
  end
end
