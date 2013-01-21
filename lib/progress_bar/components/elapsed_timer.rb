class ProgressBar
  module Components
    class ElapsedTimer
      include Timer

      def to_s
        "Time: #{elapsed_time}"
      end

      def awhile?(after_elapsed)
        elapsed_seconds >= after_elapsed
      end

    private
      def elapsed_time
        return '--:--:--' unless started?

        hours, minutes, seconds = divide_seconds(elapsed_seconds)

        sprintf TIME_FORMAT, hours, minutes, seconds
      end
    end
  end
end
