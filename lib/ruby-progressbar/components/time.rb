class ProgressBar
  module Components
    class Time
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

      def estimated_with_label
        " ETA: #{estimated}"
      end

      def elapsed_with_label
        "Time: #{elapsed}"
      end

      def estimated_time_with_no_oob
        self.out_of_bounds_time_format = nil

        estimated_with_elapsed_fallback
      end

      def estimated_time_with_unknown_oob
        self.out_of_bounds_time_format = :unknown

        estimated_with_elapsed_fallback
      end

      def estimated_time_with_friendly_oob
        self.out_of_bounds_time_format = :friendly

        estimated_with_elapsed_fallback
      end

    private

      def estimated
        return '??:??:??' if @progress.running_average.zero? || @progress.total.nil? || @timer.reset?

        hours, minutes, seconds = *@timer.divide_seconds(estimated_seconds_remaining)

        if hours > 99 && @out_of_bounds_time_format
          out_of_bounds_time
        else
          sprintf ProgressBar::Timer::TIME_FORMAT, hours, minutes, seconds
        end
      end

      def elapsed
        return '--:--:--' unless @timer.started?

        hours, minutes, seconds = @timer.divide_seconds(@timer.elapsed_whole_seconds)

        sprintf ProgressBar::Timer::TIME_FORMAT, hours, minutes, seconds
      end

      def estimated_with_elapsed_fallback
        @progress.finished? ? elapsed_with_label : estimated_with_label
      end

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
