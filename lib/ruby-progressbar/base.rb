class ProgressBar
  class Base
    include ProgressBar::LengthCalculator
    include ProgressBar::Formatter

    DEFAULT_OUTPUT_STREAM = $stdout

    def initialize(options = {})
      self.output       = options[:output] || DEFAULT_OUTPUT_STREAM
      autostart         = options.fetch(:autostart, true)

      super(options)

      @bar              = Components::Bar.new(options)
      @estimated_time   = Components::EstimatedTimer.new(options)
      @elapsed_time     = Components::ElapsedTimer.new
      @throttle         = Components::Throttle.new(options)

      start :at => options[:starting_at] if autostart
    end

    ###
    # Starting The Bar
    #
    def start(options = {})
      clear

      with_update do
        with_progressables(:start, options)
        with_timers(:start)
      end
    end

    ###
    # Updating The Bar's Progress
    #
    def decrement
      update_progress(:decrement)
    end

    def increment
      update_progress(:increment)
    end

    def progress=(new_progress)
      update_progress(:progress=, new_progress)
    end

    def total=(new_total)
      update_progress(:total=, new_total)
    end

    ###
    # Stopping The Bar
    #
    def finish
      with_update { with_progressables(:finish); with_timers(:stop) } unless finished?
    end

    def pause
      with_update { with_timers(:pause) } unless paused?
    end

    def stop
      with_update { with_timers(:stop) } unless stopped?
    end

    def resume
      with_update { with_timers(:resume) } if stopped?
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
      @estimated_time.finished? && @bar.finished?
    end

    def started?
      @estimated_time.started? && @elapsed_time.started? && @bar.started?
    end

    ###
    # UI Updates
    #
    def progress_mark=(mark)
      with_update { @bar.progress_mark = mark }
    end

    def remainder_mark=(mark)
      with_update { @bar.remainder_mark = mark }
    end

    def title=(title)
      with_update { super }
    end

    ###
    # Output
    #
    def clear
      self.last_update_length = 0

      if output.tty?
        output.print clear_string
        output.print "\r"
      else
        output.print "\n"
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
    attr_accessor   :output,
                    :last_update_length

    def clear_string
      "#{" " * length}"
    end

    def last_update_length
      @last_update_length ||= 0
    end

    def with_progressables(*args)
      @bar.send(*args)
      @estimated_time.send(*args)
    end

    def with_timers(*args)
      @estimated_time.send(*args)
      @elapsed_time.send(*args)
    end

    def update_progress(*args)
      with_update do
        with_progressables(*args)
        with_timers(:stop) if finished?
      end
    end

    def with_update
      yield
      update
    end

    def update(options = {})
      if length_changed?
        clear
        reset_length
      end

      @throttle.choke( stopped? || options[:force] ) do
        if output.tty?
          formatted_string = self.to_s
          output_string    = formatted_string
        else
          formatted_string = self.to_s(DEFAULT_NON_TTY_FORMAT_STRING)
          formatted_string = formatted_string[0...-1] unless finished?

          output_string    = formatted_string[last_update_length..-1]
        end

        self.last_update_length = formatted_string.length

        output.print output_string + eol
        output.flush
      end
    end

    def eol
      if output.tty?
        stopped? ? "\n" : "\r"
      else
        stopped? ? "\n" : ""
      end
    end
  end
end
