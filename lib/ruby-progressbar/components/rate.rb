class ProgressBar
  module Components
    class Rate
      include Timer
      include Progressable

      attr_accessor :rate_scale

      def initialize(options = {})
        self.rate_scale = options[:rate_scale]

        super
      end

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

        base_rate   = (progress_made / elapsed)

        if rate_scale
          scaled_rate = rate_scale.call(base_rate)
        else
          scaled_rate = base_rate
        end

        format_string % scaled_rate
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
