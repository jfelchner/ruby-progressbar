module ProgressBar
  module Components
    class Timer
      def start
        @started_at = Time.now
      end

      def stop
        @stopped_at = Time.now
      end

      def to_s
        "Time: #{elapsed_time}"
      end

      def started?
        !!@started_at
      end

      def stopped?
        !!@stopped_at
      end

      private
        def elapsed_time
          return "--:--:--" unless started?

          seconds = ((@stopped_at || Time.now) - @started_at).floor
          hours, seconds = seconds.divmod(3600)
          minutes, seconds = seconds.divmod(60)

          sprintf "%02d:%02d:%02d", hours, minutes, seconds
        end
    end
  end
end
