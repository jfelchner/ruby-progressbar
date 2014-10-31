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

      @timer            = Timer.new(options)
      @progress         = Progress.new(options)
      @throttle         = Throttle.new(options.merge(:timer => @timer))
      @length_calc      = LengthCalculator.new(options)

      @bar              = Components::Bar.new(options.merge(:progress => @progress))
      @rate             = Components::Rate.new(options.merge(:timer => @timer, :progress => @progress))
      @time             = Components::Time.new(options.merge(:timer => @timer, :progress => @progress))

      start :at => options[:starting_at] if autostart
    end

    def start(options = {})
      clear

      with_update do
        @progress.start(options)
        @timer.start
      end
    end

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

    def finish
      with_update { @progress.finish; @timer.stop } unless finished?
    end

    def pause
      with_update { @timer.pause } unless paused?
    end

    def stop
      with_update { @timer.stop } unless stopped?
    end

    def resume
      with_update { @timer.resume } if stopped?
    end

    def reset
      with_update do
        @progress.reset
        @timer.reset
      end
    end

    def stopped?
      @timer.stopped? || finished?
    end

    alias :paused? :stopped?

    def finished?
      @progress.finished?
    end

    def started?
      @timer.started? && @progress.started?
    end

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
      @progress.progress
    end

    def total
      @progress.total
    end

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

    def update_progress(*args)
      with_update do
        @progress.send(*args)
        @timer.stop if finished?
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
      @progress.percentage_completed
    end

    def justified_percentage
      @progress.percentage_completed.to_s.rjust(3)
    end

    def percentage_with_precision
      @progress.percentage_completed_with_precision
    end

    def justified_percentage_with_precision
      @progress.percentage_completed_with_precision.to_s.rjust(6)
    end

    def elapsed_time
      @time.elapsed_time_to_s
    end

    def estimated_time_with_no_oob
      @time.out_of_bounds_time_format = nil
      estimated_time
    end

    def estimated_time_with_unknown_oob
      @time.out_of_bounds_time_format = :unknown
      estimated_time
    end

    def estimated_time_with_friendly_oob
      @time.out_of_bounds_time_format = :friendly
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
      finished? ? @time.elapsed_time_to_s : @time.estimated_with_label
    end
  end
end
