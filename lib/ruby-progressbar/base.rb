class ProgressBar
  class Base
    include ProgressBar::LengthCalculator
    include ProgressBar::Formatter

    DEFAULT_OUTPUT_STREAM = $stdout

    def initialize(options = {})
      self.output       = options[:output] || DEFAULT_OUTPUT_STREAM

      super(options)

      @bar              = Components::Bar.new(options)
      @estimated_time   = Components::EstimatedTimer.new(options)
      @elapsed_time     = Components::ElapsedTimer.new
      @throttle         = Components::Throttle.new(options)

      start :at => options[:starting_at]
    end

    ###
    # Starting The Bar
    #
    def start(options = {})
      clear

      with_update do
        with_progressables(:start, options)
        @elapsed_time.start
      end
    end

    ###
    # Updating The Bar's Progress
    #
    def decrement
      with_update { with_progressables(:decrement) }
    end

    def increment
      with_update { with_progressables(:increment) }
    end

    def progress=(new_progress)
      with_update { with_progressables(:progress=, new_progress) }
    end

    def total=(new_total)
      with_update { with_progressables(:total=, new_total) }
    end

    ###
    # Stopping The Bar
    #
    def finish
      with_update { with_progressables(:finish) }
    end

    def pause
      with_update { with_timers(:pause) }
    end

    def stop
      with_update { with_timers(:stop) }
    end

    def resume
      with_update { with_timers(:resume) }
    end

    def reset
      with_update do
        @bar.reset
        with_timers(:reset)
      end
    end

    def stopped?
      (@estimated_time.stopped? && @elapsed_time.stopped?) || finished?
    end

    alias :paused? :stopped?

    def finished?
      @bar.progress == @bar.total
    end

    ###
    # UI Updates
    #
    def progress_mark=(mark)
      with_update { @bar.progress_mark = mark }
    end

    def title=(title)
      with_update { super }
    end

    ###
    # Output
    #
    def clear
      if output.tty?
        output.print clear_string
        output.print "\r"
      end
    end

    def refresh
      update
    end

    def log(string)
      clear
      output.puts string

      update(:force => true) unless stopped?
    end

    def to_s(format_string = nil)
      format_string ||= @format_string

      format(format_string)
    end

    def inspect
      "#<ProgressBar:#{progress}/#{total || 'unknown'}>"
    end

  private
    attr_accessor   :output

    def clear_string
      "#{" " * length}"
    end

    def with_progressables(*args)
      @bar.send(*args)
      @estimated_time.send(*args)
    end

    def with_timers(*args)
      @estimated_time.send(*args)
      @elapsed_time.send(*args)
    end

    def with_update
      yield
      update
    end

    def update(options = {})
      if output.tty? || stopped?
        with_timers(:stop) if finished?

        @throttle.choke( stopped? || options[:force] ) do
          if length_changed?
            clear
            reset_length
          end

          output.print self.to_s + eol
          output.flush
        end
      end
    end

    def eol
      stopped? ? "\n" : "\r"
    end
  end
end
