module ProgressBar
  module Components
    class EstimatedTimer
      include Timer
      include Progressable

      VALID_OOB_TIME_FORMATS = [:unknown, :friendly, nil]

      def initialize(options = {})
        initialize_progress(options)
      end

      def start(options = {})
        as(Timer).start
        as(Progressable).start(options)
      end

      def reset
        as(Timer).reset
        as(Progressable).reset
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
          return "??:??:??" if progress_made.zero?

          hours, minutes, seconds = divide_seconds(estimated_seconds_remaining)

          if hours > 99 && @out_of_bounds_time_format
            out_of_bounds_time
          else
            sprintf TIME_FORMAT, hours, minutes, seconds
          end
        end

        def seconds_per_each
          elapsed_seconds.to_f / progress_made
        end

        def estimated_seconds_remaining
          (seconds_per_each * (@total - @progress)).floor
        end

        def out_of_bounds_time
          case @out_of_bounds_time_format
          when :unknown
            '??:??:??'
          when :friendly
            '> 4 Days'
          end
        end

        def as(ancestor, &blk)
          @__as ||= {}
          unless r = @__as[ancestor]
            r = (@__as[ancestor] = As.new(self, ancestor))
          end
          r.instance_eval(&blk) if block_given?
          r
        end

        class As
          private *instance_methods.select { |m| m !~ /(^__|^\W|^binding$)/ }

          def initialize(subject, ancestor)
            @subject = subject
            @ancestor = ancestor
          end

          def method_missing(sym, *args, &blk)
            @ancestor.instance_method(sym).bind(@subject).call(*args,&blk)
          end
        end
    end
  end
end
