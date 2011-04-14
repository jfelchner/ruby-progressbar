module ProgressBar
  module Components
    class EstimatedTimer
      include Timer

      VALID_OOB_TIME_FORMATS = [:unknown, :friendly, nil]

      #TODO These could be private right now.
      attr_reader               :total
      attr_reader               :current

      def initialize(options = {})
        @current = options[:current] || 0
        @total   = options[:total]   || raise("You have to pass the total capacity to find an estimate.")
      end

      def increment
        @current += 1 unless current == total
      end

      def current=(new_current)
        raise "You can't set the item's current value to be greater than the total." if new_current > total

        @current = new_current
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
