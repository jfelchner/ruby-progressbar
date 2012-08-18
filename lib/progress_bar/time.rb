class ProgressBar
  class Time
    def self.now(time = ::Time)
      @@time = time

      @@time.send unmocked_time_method
    end

  private
    def self.unmocked_time_method
      time_mocking_library_mapping.values.find { |method| @@time.respond_to? method }
    end

    def self.time_mocking_library_mapping
      {
        :timecop  => :now_without_mock_time,
        :delorean => :now_without_delorean,
        :actual   => :now
      }
    end
  end
end
