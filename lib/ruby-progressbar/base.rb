require 'ruby-progressbar/length_calculator'

class ProgressBar
  class Base
    DEFAULT_OUTPUT_STREAM = $stdout
    DEFAULT_FORMAT_STRING         = '%t: |%B|'
    DEFAULT_NON_TTY_FORMAT_STRING = '%t: |%b|'
    DEFAULT_TITLE                 = 'Progress'

    def initialize(options = {})
      self.output       = options[:output] || DEFAULT_OUTPUT_STREAM
      autostart         = options.fetch(:autostart, true)

      @format_string     = nil
      self.format_string = options[:format] || DEFAULT_FORMAT_STRING
      @title             = options[:title]  || DEFAULT_TITLE

      @timer            = Components::Timer.new(options)
      @length_calc      = LengthCalculator.new(options)
      @bar              = Components::Bar.new(options)
      @rate             = Components::Rate.new(options.merge(:timer => @timer))
      @estimated_time   = Components::EstimatedTimer.new(options.merge(:timer => @timer))
      @elapsed_time     = Components::ElapsedTimer.new({:timer => @timer})
      @throttle         = Components::Throttle.new(options.merge(:timer => @timer))

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
      @timer.stopped? || finished?
    end

    alias :paused? :stopped?

    def finished?
      @estimated_time.finished? && @bar.finished?
    end

    def started?
      @timer.started? && @bar.started?
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
      if output.tty?
        with_update { @title = title }
      end
    end

    def format(new_format_string = DEFAULT_FORMAT_STRING)
      self.format_string = new_format_string
      @format.process(self)
    end

    def progress
      @bar.progress
    end

    def total
      @bar.total
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

  protected

    attr_accessor :output,
                  :last_update_length

  private

    def clear_string
      "#{" " * @length_calc.length}"
    end

    def last_update_length
      @last_update_length ||= 0
    end

    def with_progressables(*args)
      @bar.send(*args)
      @estimated_time.send(*args)
      @rate.send(*args)
    end

    def with_timers(*args)
      @timer.send(*args)
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
      if @length_calc.length_changed?
        clear
        @length_calc.reset_length
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

    def format_string=(format_string)
      if @format_string != format_string
        @format_string = format_string
        @format        = ProgressBar::Format::Base.new(format_string)
      end
    end

    # Format Methods
    def title
      @title
    end

    def percentage
      @bar.percentage_completed
    end

    def justified_percentage
      @bar.percentage_completed.to_s.rjust(3)
    end

    def percentage_with_precision
      @bar.percentage_completed_with_precision
    end

    def justified_percentage_with_precision
      @bar.percentage_completed_with_precision.to_s.rjust(6)
    end

    def elapsed_time
      @elapsed_time
    end

    def estimated_time_with_no_oob
      @estimated_time.out_of_bounds_time_format = nil
      estimated_time
    end

    def estimated_time_with_unknown_oob
      @estimated_time.out_of_bounds_time_format = :unknown
      estimated_time
    end

    def estimated_time_with_friendly_oob
      @estimated_time.out_of_bounds_time_format = :friendly
      estimated_time
    end

    def bar(length)
      @bar.length = length
      @bar.standard_complete_string
    end

    def complete_bar(length)
      @bar.length = length
      @bar.to_s
    end

    def incomplete_space(length)
      @bar.length = length
      @bar.empty_string
    end

    def bar_with_percentage(length)
      @bar.length = length
      @bar.integrated_percentage_complete_string
    end

    def estimated_time
      finished? ? @elapsed_time : @estimated_time
    end

    def rate_of_change
      @rate.to_s
    end

    def rate_of_change_with_precision
      @rate.to_s("%.2f")
    end
  end
end
