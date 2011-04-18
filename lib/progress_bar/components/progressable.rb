module ProgressBar
  module Components
    module Progressable
      DEFAULT_TOTAL              = 100
      DEFAULT_BEGINNING_POSITION = 0

      attr_reader               :total
      attr_reader               :progress

      def initialize_progress(options)
        self.total    = options[:total]             || DEFAULT_TOTAL
      end

      def start(options = {})
        self.progress = options[:at] || DEFAULT_BEGINNING_POSITION

        @starting_position = self.progress
      end

      def started?
        !!@starting_position
      end

      def increment
        @progress += 1 unless progress == total
      end

      def decrement
        @progress -= 1 unless progress == 0
      end

      def reset
        @progress = @starting_position
      end

      def progress=(new_progress)
        validate_progress(new_progress)
        @progress = new_progress
      end

      def total=(new_total)
        validate_total(new_total)
        @total = new_total
      end

      def finish
        @progress = @total
      end

      def percentage_completed
        # progress / total * 100
        #
        # Doing this way so we can avoid converting each
        # number to a float and then back to an integer.
        #
        progress * 100 / total
      end

      def percentage_completed_with_precision
        format('%5.2f', (progress.to_f * 100.0 / total * 100.0).floor / 100.0)
      end

      private
        def validate_total(new_total)
          (progress.nil? || new_total >= progress) || raise("You can't set the item's total value to be less than the current progress.")
        end

        def validate_progress(new_progress)
          (total.nil? || new_progress <= total) || raise("You can't set the item's current value to be greater than the total.")
        end

        def progress_made
          started? ? @progress - @starting_position : 0
        end
    end
  end
end
