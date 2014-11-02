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

      @format            = nil
      self.format        = options[:format] || DEFAULT_FORMAT_STRING
      @title             = options[:title]  || DEFAULT_TITLE

      @timer            = Timer.new(options)
      @progress         = Progress.new(options)
      @throttle         = Throttle.new(options.merge(:timer => @timer))
      @length_calc      = LengthCalculator.new(options)

      @bar              = Components::Bar.new(options.merge(:progress => @progress))
      @percentage       = Components::Percentage.new(:progress => @progress)
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

    def to_s(format = nil)
      self.format = format if format

      formatter.process(self)
    end

    def inspect
      "#<ProgressBar:#{progress}/#{total || 'unknown'}>"
    end

    def format=(other)
      @formatter = nil
      @format = (other || DEFAULT_FORMAT_STRING)
    end

    def formatter
      @formatter ||= ProgressBar::Format::Base.new(@format)
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

    # Format Methods
    def title
      @title
    end
  end
end
