require 'ruby-progressbar/time'

class ProgressBar
  module Components
    module Timer
      TIME_FORMAT = '%02d:%02d:%02d'

      def start
        @started_at = stopped? ? now - (@stopped_at - @started_at) : now
        @stopped_at = nil
      end

      def stop
        return unless started?

        @stopped_at = now
      end

      def pause
        stop
      end

      def resume
        start
      end

      def started?
        !!@started_at
      end

      def stopped?
        !!@stopped_at
      end

      def reset
        @started_at = nil
        @stopped_at = nil
      end

    private
      def now
        ProgressBar::Time.now
      end

      def elapsed_seconds
        ((@stopped_at || now) - @started_at)
      end

      def elapsed_whole_seconds
        elapsed_seconds.floor
      end

      def elapsed_time
        return '--:--:--' unless started?

        hours, minutes, seconds = *divide_seconds(elapsed_whole_seconds)

        sprintf TIME_FORMAT, hours, minutes, seconds
      end

      def divide_seconds(seconds)
        hours, seconds = seconds.divmod(3600)
        minutes, seconds = seconds.divmod(60)

        [hours, minutes, seconds]
      end
    end
  end
end
