class ProgressBar
  module Components
    class Bar
      include Progressable

      DEFAULT_PROGRESS_MARK = 'o'

      attr_accessor :mirrored
      attr_accessor :progress_mark
      attr_accessor :length

      def initialize(options = {})
        super

        self.mirrored        = false
        self.progress_mark   = options[:progress_mark] || DEFAULT_PROGRESS_MARK
      end

      def mirror
        self.mirrored = !mirrored
      end

      def mirrored?
        mirrored
      end

      def to_s(options = {:format => :standard})
        completed_string = send(:"#{options[:format]}_complete_string")
        empty_string     = ' ' * (length - completed_string.length)

        mirrored? ? "#{empty_string}#{completed_string}" : "#{completed_string}#{empty_string}"
      end

      def integrated_percentage_complete_string
        " #{percentage_completed} ".to_s.center(completed_length, progress_mark)
      end

      def standard_complete_string
        progress_mark * completed_length
      end

    private
      def completed_length
        length * percentage_completed / 100
      end

      def empty_string
        ' ' * (length - completed_length)
      end
    end
  end
end
