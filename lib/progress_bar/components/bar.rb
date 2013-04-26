class ProgressBar
  module Components
    class Bar
      include Progressable

      DEFAULT_PROGRESS_MARK = '='

      attr_accessor :progress_mark
      attr_accessor :length

      def initialize(options = {})
        super

        self.progress_mark   = options[:progress_mark] || DEFAULT_PROGRESS_MARK
      end

      def to_s(options = {:format => :standard})
        completed_string = send(:"#{options[:format]}_complete_string")
        completed_string.ljust(length, ' ')
      end

      def integrated_percentage_complete_string
        return standard_complete_string if completed_length < 5

        " #{percentage_completed} ".to_s.center(completed_length, progress_mark)
      end

      def standard_complete_string
        progress_mark * completed_length
      end

      def empty_string
        ' ' * (length - completed_length)
      end

    private
      def completed_length
        length * percentage_completed / 100
      end
    end
  end
end
