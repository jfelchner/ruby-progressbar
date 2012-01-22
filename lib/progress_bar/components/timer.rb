module ProgressBar
  module Components
    module Timer
      TIME_FORMAT = "%02d:%02d:%02d"

      def start
        @started_at = stopped? ? Time.now - (@stopped_at - @started_at) : Time.now
      end

      def stop
        @stopped_at = Time.now
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
      def elapsed_seconds
        ((@stopped_at || Time.now) - @started_at).floor
      end

      def elapsed_time
        return "--:--:--" unless started?

        hours, seconds = elapsed_seconds.divmod(3600)
        minutes, seconds = seconds.divmod(60)

        sprintf "%02d:%02d:%02d", hours, minutes, seconds
      end

      def divide_seconds(seconds)
        hours, seconds = seconds.divmod(3600)
        minutes, seconds = seconds.divmod(60)

        [hours, minutes, seconds]
      end
    end
  end
end
