class ProgressBar
  module Components
    class EstimatedTimer
      VALID_OOB_TIME_FORMATS = [:unknown, :friendly, nil]

      def initialize(options = {})
        @out_of_bounds_time_format = nil
        @timer                     = options[:timer]
        @progressable              = options[:progress]
      end

      def out_of_bounds_time_format=(format)
        raise "Invalid Out Of Bounds time format.  Valid formats are #{VALID_OOB_TIME_FORMATS.inspect}" unless VALID_OOB_TIME_FORMATS.include? format

        @out_of_bounds_time_format = format
      end

      def to_s
        " ETA: #{estimated_time}"
      end

    private
      def estimated_time
        return '??:??:??' if @progressable.running_average.zero? || @progressable.total.nil? || @timer.reset?

        hours, minutes, seconds = *@timer.divide_seconds(estimated_seconds_remaining)

        if hours > 99 && @out_of_bounds_time_format
          out_of_bounds_time
        else
          sprintf ProgressBar::Components::Timer::TIME_FORMAT, hours, minutes, seconds
        end
      end

      def estimated_seconds_remaining
        (@timer.elapsed_seconds * (@progressable.total / @progressable.running_average  - 1)).round
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
