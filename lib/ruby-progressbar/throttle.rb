class ProgressBar
    class Throttle
      attr_accessor :period,
                    :started_at,
                    :stopped_at,
                    :timer

      def initialize(options = {})
        self.period     = options.delete(:throttle_rate) { 0.01 } || 0.01
        self.started_at = nil
        self.stopped_at = nil
        self.timer      = options[:timer]
      end

      def choke(options = {}, &block)
        force = options.fetch(:force_update_if, false)

        if !timer.started? || period.nil? || force || timer.elapsed_seconds >= period
          yield
        end
      end
    end
end
