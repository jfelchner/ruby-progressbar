module ProgressBar
  module Components
    class EstimatedTimer
      include Timer
      include Progressable

      VALID_OOB_TIME_FORMATS = [:unknown, :friendly, nil]

      def initialize(options = {})
        initialize_progress(options)
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
            sprintf TIME_FORMAT, hours, minutes, seconds
          end
        end

        def seconds_per_each
          elapsed_seconds.to_f / @current
        end

        def estimated_seconds_remaining
          (seconds_per_each * (@total - @current)).floor
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
