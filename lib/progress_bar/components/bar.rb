module ProgressBar
  class Bar
    OPTIONS                    = [:total, :progress_mark, :beginning_position]

    DEFAULT_TOTAL              = 100
    DEFAULT_BEGINNING_POSITION = 0
    DEFAULT_PROGRESS_MARK      = 'o'

    #TODO These could be private right now.
    attr_reader               :total
    attr_reader               :current
    attr_reader               :progress_mark

    def initialize(options = {})
      @total           = options[:total]              || DEFAULT_TOTAL
      @current         = options[:beginning_position] || DEFAULT_BEGINNING_POSITION

      raise "You can't set the bar's current value to be greater than the total." if current > total

      @progress_mark   = options[:progress_mark]      || DEFAULT_PROGRESS_MARK
    end

    def increment
      @current += 1 unless current == total
    end

    #TODO needs tested
    def current=(new_current)
      raise "You can't set the bar's current value to be greater than the total." if new_current > total

      @current = new_current
    end

    def percentage_completed
      # current / total * 100
      #
      # Doing this way so we can avoid converting each
      # number to a float and then back to an integer.
      #
      current * 100 / total
    end

    def to_s(length)
      @length = length
      "#{complete_string}#{empty_string}"
    end

    private
      attr_reader :length

      def complete_string
        @progress_mark * completed_length
      end

      def completed_length
        length * percentage_completed / 100
      end

      def empty_string
        " " * (length - completed_length)
      end
  end
end
