class ProgressBar
  class Output
    DEFAULT_OUTPUT_STREAM = $stdout
    DEFAULT_NON_TTY_FORMAT_STRING = '%t: |%b|'

    attr_accessor :stream

    def initialize(options = {})
      self.bar    = options[:bar]
      self.stream      = options[:output] || DEFAULT_OUTPUT_STREAM
      self.length_calc = LengthCalculator.new(options)
      self.throttle    = Throttle.new(options.merge(:timer => options[:timer]))
    end

    def clear
      self.last_update_length = 0

      if stream.tty?
        stream.print clear_string
        stream.print "\r"
      else
        stream.print "\n"
      end
    end

    def log(string)
      clear
      stream.puts string

      update(:force => true) unless bar.stopped?
    end

    def clear_string
      "#{" " * length_calc.length}"
    end

    def last_update_length
      @last_update_length ||= 0
    end

    def with_update
      yield
      update
    end

    def tty?
      stream.tty?
    end

    def update(options = {})
      if length_calc.length_changed?
        clear
        length_calc.reset_length
      end

      throttle.choke( bar.stopped? || options[:force] ) do
        if stream.tty?
          formatted_string = bar.to_s
          output_string    = formatted_string
        else
          formatted_string = bar.to_s(DEFAULT_NON_TTY_FORMAT_STRING)
          formatted_string = formatted_string[0...-1] unless bar.finished?

          output_string    = formatted_string[last_update_length..-1]
        end

        self.last_update_length = formatted_string.length

        stream.print output_string + eol
        stream.flush
      end
    end

    def eol
      if stream.tty?
        bar.stopped? ? "\n" : "\r"
      else
        bar.stopped? ? "\n" : ""
      end
    end

    protected

    attr_accessor :last_update_length,
                  :length_calc,
                  :throttle,
                  :bar
  end
end
