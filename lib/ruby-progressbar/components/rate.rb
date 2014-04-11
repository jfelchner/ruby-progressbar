class ProgressBar
  module Components
    class Rate
      include Timer
      include Progressable

      def start(options = {})
        as(Timer).start
        as(Progressable).start(options)
      end

      def reset
        as(Timer).reset
        as(Progressable).reset
      end

      def to_s(format_string = "%i")
        elapsed = elapsed_whole_seconds.to_f
        return 0 unless elapsed > 0

        format_string % (progress_made / elapsed)
      end

    private

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

        def start(*args, &blk)
          @ancestor.instance_method(:start).bind(@subject).call(*args,&blk)
        end

        def method_missing(sym, *args, &blk)
          @ancestor.instance_method(sym).bind(@subject).call(*args,&blk)
        end
      end
    end
  end
end
