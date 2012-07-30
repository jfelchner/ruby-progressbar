class ProgressBar
  class Time
    def self.now(time = ::Time)
      @@time = time

      @@time.now
    end
  end
end
