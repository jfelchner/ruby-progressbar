module ProgressBar
  module Components
    module Progressable
      DEFAULT_TOTAL              = 100
      DEFAULT_BEGINNING_POSITION = 0

      attr_reader               :total
      attr_reader               :current

      def initialize_progress(options)
        self.total   = options[:total]             || DEFAULT_TOTAL
        self.current = options[:starting_at]       || DEFAULT_BEGINNING_POSITION
      end

      def start(options = {})
        self.current = options[:at] || self.current

        @starting_position = self.current
      end

      def started?
        !!@starting_position
      end

      def increment
        @current += 1 unless current == total
      end

      def reset
        @current = @starting_position
      end

      def current=(new_current)
        validate_current(new_current)
        @current = new_current
      end

      def total=(new_total)
        validate_total(new_total)
        @total = new_total
      end

      def finish
        @current = @total
      end

      def percentage_completed
        # current / total * 100
        #
        # Doing this way so we can avoid converting each
        # number to a float and then back to an integer.
        #
        current * 100 / total
      end

      def percentage_completed_with_precision
        format('%5.2f', (current.to_f * 100.0 / total * 100.0).floor / 100.0)
      end

      private
        def validate_total(new_total)
          (current.nil? || new_total >= current) || raise("You can't set the item's total value to be less than the current progress.")
        end

        def validate_current(new_current)
          (total.nil? || new_current <= total) || raise("You can't set the item's current value to be greater than the total.")
        end

        def progress_made
          started? ? @current - @starting_position : 0
        end
    end
  end
end
