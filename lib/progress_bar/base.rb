class ProgressBar
  class Base
    include ProgressBar::LengthCalculator
    include ProgressBar::Formatter
    include ProgressBar::Depreciable

    DEFAULT_OUTPUT_STREAM     = STDOUT

    def initialize(*args)
      options          = args.empty? ? {} : backwards_compatible_args_to_options_conversion(args)

      self.output      = options[:output]                || DEFAULT_OUTPUT_STREAM

      super(options)

      @bar             = Components::Bar.new(options)
      @estimated_time  = Components::EstimatedTimer.new(options)
      @elapsed_time    = Components::ElapsedTimer.new

      start :at => options[:starting_at]
    end

    def clear
      output.print clear_string
    end

    def start(options = {})
      clear

      with_update do
        with_progressables(:start, options)
        @elapsed_time.start
      end
    end

    def finish
      with_update { with_progressables(:finish) }
    end

    def finished?
      @bar.progress == @bar.total
    end

    def decrement
      with_update { with_progressables(:decrement) }
    end

    def increment
      with_update { with_progressables(:increment) }
    end

    def progress=(new_progress)
      with_update { with_progressables(:progress=, new_progress) }
    end

    def reset
      with_update do
        @bar.reset
        with_timers(:reset)
      end
    end

    def pause
      with_update { with_timers(:pause) }
    end

    def stop
      with_update { with_timers(:stop) }
    end

    def stopped?
      @estimated_time.stopped? && @elapsed_time.stopped?
    end

    alias :paused? :stopped?

    def resume
      with_update { with_timers(:resume) }
    end

    def progress_mark=(mark)
      with_update { @bar.progress_mark = mark }
    end

    def title=(title)
      with_update { super }
    end

    def to_s(format_string = nil)
      format_string ||= @format_string

      format(format_string)
    end

    def inspect
      "#<ProgressBar:#{progress}/#{total}>"
    end

  private
    attr_accessor   :output

    def clear_string
      "#{" " * length}\r"
    end

    def with_progressables(action, *args)
      if args.empty?
        @bar.send(action)
        @estimated_time.send(action)
      else
        @bar.send(action, *args)
        @estimated_time.send(action, *args)
      end
    end

    def with_timers(action, *args)
      if args.empty?
        @estimated_time.send(action)
        @elapsed_time.send(action)
      else
        @estimated_time.send(action, *args)
        @elapsed_time.send(action, *args)
      end
    end

    def with_update
      yield
      update
    end

    def update
      with_timers(:stop) if finished?

      if length_changed?
        clear
        reset_length
      end

      output.print self.to_s + eol
      output.flush
    end

    def eol
      finished? || stopped? ? "\n" : "\r"
    end
  end
end
