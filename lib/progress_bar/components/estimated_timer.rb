module ProgressBar
  module Components
    class EstimatedTimer
      def initialize(options = {})
        @current = options[:current] || 0
        @total   = options[:total]   || raise("You have to pass the total capacity to find an estimate.")
      end

      def start
        @started_at = Time.now
      end

      def increment
        @current += 1 unless current == total
      end

      def to_s
        " ETA: #{estimated_time}"
      end

      private
        def estimated_time
          return "??:??:??" if @current == 0

          hours, minutes, seconds = divide_seconds(estimated_seconds_remaining)

          hours <= 99 ? sprintf("%02d:%02d:%02d", hours, minutes, seconds) : "> 4 Days"
        end

        def elapsed_seconds
          Time.now - @started_at
        end

        def seconds_per_each
          elapsed_seconds / @current
        end

        def estimated_seconds_remaining
          (seconds_per_each * (@total - @current)).floor
        end

        def divide_seconds(seconds)
          hours, seconds = seconds.divmod(3600)
          minutes, seconds = seconds.divmod(60)

          [hours, minutes, seconds]
        end
    end
  end
end
