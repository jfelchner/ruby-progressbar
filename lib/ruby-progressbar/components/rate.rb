class ProgressBar
  module Components
    class Rate
      attr_accessor :rate_scale

      def initialize(options = {})
        self.rate_scale = options[:rate_scale]
        @started_at     = nil
        @stopped_at     = nil
        @timer          = options[:timer]
        @progress       = options[:progress]
      end

      def to_s(format_string = "%i")
        elapsed = @timer.elapsed_whole_seconds.to_f
        return 0 unless elapsed > 0

        base_rate   = (@progress.absolute / elapsed)

        if rate_scale
          scaled_rate = rate_scale.call(base_rate)
        else
          scaled_rate = base_rate
        end

        format_string % scaled_rate
      end

      alias_method :rate_of_change, :to_s

      def rate_of_change_with_precision
        to_s("%.2f")
      end
    end
  end
end
