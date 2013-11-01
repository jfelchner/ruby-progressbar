class ProgressBar
  module Components
    class Bar
      include Progressable

      DEFAULT_PROGRESS_MARK                    = '='
      DEFAULT_REMAINDER_MARK                   = ' '
      DEFAULT_UNKNOWN_PROGRESS_ANIMATION_STEPS = ['=---', '-=--', '--=-', '---=']

      attr_accessor :progress_mark
      attr_accessor :remainder_mark
      attr_accessor :length
      attr_accessor :unknown_progress_animation_steps

      def initialize(options = {})
        super

        self.unknown_progress_animation_steps = options[:unknown_progress_animation_steps] || DEFAULT_UNKNOWN_PROGRESS_ANIMATION_STEPS
        self.progress_mark                    = options[:progress_mark]                    || DEFAULT_PROGRESS_MARK
        self.remainder_mark                   = options[:remainder_mark]                   || DEFAULT_REMAINDER_MARK
      end

      def to_s(options = {:format => :standard})
        completed_string = send(:"#{options[:format]}_complete_string")

        "#{completed_string}#{empty_string}"
      end

      def integrated_percentage_complete_string
        return standard_complete_string if completed_length < 5

        " #{percentage_completed} ".to_s.center(completed_length, progress_mark)
      end

      def standard_complete_string
        progress_mark * completed_length
      end

      def empty_string
        incomplete_length = (length - completed_length)

        if total.nil?
          current_animation_step = progress % unknown_progress_animation_steps.size
          animation_graphic      = unknown_progress_animation_steps[current_animation_step]

          unknown_incomplete_string = animation_graphic * ((incomplete_length / unknown_progress_animation_steps.size) + 2)

          unknown_incomplete_string[0, incomplete_length]
        else
          remainder_mark * incomplete_length
        end
      end

    private
      def completed_length
        (length * percentage_completed / 100).floor
      end
    end
  end
end
