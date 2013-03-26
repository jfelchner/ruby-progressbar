class ProgressBar
  module Components
    class Throttle
      include Timer

      def initialize options = {}
        @period = options.delete :throttle_period
      end

      def choke force=false, &block
        if not started? or not @period or force or elapsed >= @period
          yield
          start
        end
      end

      private

      def elapsed
        now - @started_at
      end
    end
  end
end
