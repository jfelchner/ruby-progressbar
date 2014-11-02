class ProgressBar
  class Output
    DEFAULT_OUTPUT_STREAM = $stdout

    attr_accessor :stream

    def initialize(options = {})
      self.bar    = options[:bar]
      self.stream      = options[:output] || DEFAULT_OUTPUT_STREAM
      self.length_calc = LengthCalculator.new(options)
      self.throttle    = Throttle.new(options.merge(:timer => options[:timer]))
    end

    def self.detect(options = {})
      if (options[:output] || DEFAULT_OUTPUT_STREAM).tty?
        TtyOutput.new(options)
      else
        NonTtyOutput.new(options)
      end
    end

    def log(string)
      clear
      stream.puts string

      refresh(:force => true) unless bar.stopped?
    end

    def clear_string
      "#{" " * length_calc.length}"
    end

    def with_update
      yield
      refresh
    end

    def tty?
      stream.tty?
    end

    def refresh(options = {})
      if length_calc.length_changed?
        clear
        length_calc.reset_length
      end

      throttle.choke( bar.stopped? || options[:force] ) do
        stream.print bar_update_string + eol
        stream.flush
      end
    end

    protected

    attr_accessor :length_calc,
                  :throttle,
                  :bar
  end
end
