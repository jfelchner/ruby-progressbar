class ProgressBar
    class Throttle
      def initialize(options = {})
        @period     = options.delete(:throttle_rate) { 0.01 } || 0.01
        @started_at = nil
        @stopped_at = nil
        @timer      = options[:timer]
      end

      def choke(options = {}, &block)
        force = options.fetch(:force_update_if, false)

        if !@timer.started? || @period.nil? || force || @timer.elapsed_seconds >= @period
          yield
        end
      end
    end
end
