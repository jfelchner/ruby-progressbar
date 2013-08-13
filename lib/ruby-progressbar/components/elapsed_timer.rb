class ProgressBar
  module Components
    class ElapsedTimer
      include Timer

      def to_s
        "Time: #{elapsed_time}"
      end

    private
      def elapsed_time
        return '--:--:--' unless started?

        hours, minutes, seconds = divide_seconds(elapsed_whole_seconds)

        sprintf TIME_FORMAT, hours, minutes, seconds
      end
    end
  end
end
