class ProgressBar
  module Components
    class Time
      TIME_FORMAT      = '%02d:%02d:%02d'
      OOB_TIME_FORMATS = [:unknown, :friendly, nil]
      ESTIMATED_LABEL  = ' ETA'
      ELAPSED_LABEL    = 'Time'

      def initialize(options = {})
        self.out_of_bounds_time_format = nil
        self.timer                     = options[:timer]
        self.progress                  = options[:progress]
      end

      def estimated_with_label
        "#{ESTIMATED_LABEL}: #{estimated}"
      end

      def elapsed_with_label
        "#{ELAPSED_LABEL}: #{elapsed}"
      end

      def estimated_with_no_oob
        self.out_of_bounds_time_format = nil

        estimated_with_elapsed_fallback
      end

      def estimated_with_unknown_oob
        self.out_of_bounds_time_format = :unknown

        estimated_with_elapsed_fallback
      end

      def estimated_with_friendly_oob
        self.out_of_bounds_time_format = :friendly

        estimated_with_elapsed_fallback
      end

    protected

      attr_accessor :out_of_bounds_time_format,
                    :timer,
                    :progress

      def out_of_bounds_time_format=(format)
        raise "Invalid Out Of Bounds time format.  Valid formats are #{OOB_TIME_FORMATS.inspect}" unless OOB_TIME_FORMATS.include? format

        @out_of_bounds_time_format = format
      end

    private

      def estimated
        return '??:??:??' if progress.unknown? || timer.stopped?

        hours, minutes, seconds = timer.divide_seconds(estimated_seconds_remaining)

        if hours > 99 && out_of_bounds_time_format
          out_of_bounds_time
        else
          sprintf TIME_FORMAT, hours, minutes, seconds
        end
      end

      def elapsed
        return '--:--:--' unless timer.started?

        hours, minutes, seconds = timer.divide_seconds(timer.elapsed_whole_seconds)

        sprintf TIME_FORMAT, hours, minutes, seconds
      end

      def estimated_with_elapsed_fallback
        progress.finished? ? elapsed_with_label : estimated_with_label
      end

      def estimated_seconds_remaining
        (timer.elapsed_seconds * (progress.total / progress.running_average - 1)).round
      end

      def out_of_bounds_time
        case out_of_bounds_time_format
        when :unknown
          '??:??:??'
        when :friendly
          '> 4 Days'
        end
      end
    end
  end
end
