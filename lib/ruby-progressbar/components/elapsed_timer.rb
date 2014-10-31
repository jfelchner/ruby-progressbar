class ProgressBar
  module Components
    class ElapsedTimer
      def initialize(options = {})
        @started_at = nil
        @stopped_at = nil
        @timer      = options[:timer]
      end

      def to_s
        "Time: #{elapsed_time}"
      end

    private
      def elapsed_time
        return '--:--:--' unless @timer.started?

        hours, minutes, seconds = @timer.divide_seconds(@timer.elapsed_whole_seconds)

        sprintf ProgressBar::Timer::TIME_FORMAT, hours, minutes, seconds
      end
    end
  end
end
