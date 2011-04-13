module ProgressBar
  module Components
    class EstimatedTimer
      VALID_OOB_TIME_FORMATS = [:unknown, :friendly]

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

      def out_of_bounds_time_format=(format)
        if VALID_OOB_TIME_FORMATS.include? format
          @out_of_bounds_time_format = format
        else
          raise "Invalid Out Of Bounds time format.  Valid formats are #{VALID_OOB_TIME_FORMATS.inspect}"
        end
      end

      def to_s
        " ETA: #{estimated_time}"
      end

      private
        def estimated_time
          return "??:??:??" if @current == 0

          hours, minutes, seconds = divide_seconds(estimated_seconds_remaining)

          if hours > 99 && @out_of_bounds_time_format
            out_of_bounds_time
          else
            sprintf "%02d:%02d:%02d", hours, minutes, seconds
          end
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

        def out_of_bounds_time
          case @out_of_bounds_time_format
          when :unknown
            '??:??:??'
          when :friendly
            '> 4 Days'
          end
        end
    end
  end
end
