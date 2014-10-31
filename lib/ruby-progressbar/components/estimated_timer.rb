class ProgressBar
  module Components
    class EstimatedTimer
      VALID_OOB_TIME_FORMATS = [:unknown, :friendly, nil]

      def initialize(options = {})
        @out_of_bounds_time_format = nil
        @timer                     = options[:timer]
        @progress                  = options[:progress]
      end

      def out_of_bounds_time_format=(format)
        raise "Invalid Out Of Bounds time format.  Valid formats are #{VALID_OOB_TIME_FORMATS.inspect}" unless VALID_OOB_TIME_FORMATS.include? format

        @out_of_bounds_time_format = format
      end

      def to_s
        " ETA: #{estimated_time}"
      end

      def elapsed_time_to_s
        "Time: #{elapsed_time}"
      end

      def estimated_time
        return '??:??:??' if @progress.running_average.zero? || @progress.total.nil? || @timer.reset?

        hours, minutes, seconds = *@timer.divide_seconds(estimated_seconds_remaining)

        if hours > 99 && @out_of_bounds_time_format
          out_of_bounds_time
        else
          sprintf ProgressBar::Timer::TIME_FORMAT, hours, minutes, seconds
        end
      end

      def elapsed_time
        return '--:--:--' unless @timer.started?

        hours, minutes, seconds = @timer.divide_seconds(@timer.elapsed_whole_seconds)

        sprintf ProgressBar::Timer::TIME_FORMAT, hours, minutes, seconds
      end

    private

      def estimated_seconds_remaining
        (@timer.elapsed_seconds * (@progress.total / @progress.running_average  - 1)).round
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
