class ProgressBar
  class Base
    DEFAULT_FORMAT_STRING         = '%t: |%B|'
    DEFAULT_TITLE                 = 'Progress'

    attr_accessor :title

    def initialize(options = {})
      autostart         = options.fetch(:autostart, true)
      self.format       = options[:format] || DEFAULT_FORMAT_STRING
      @title            = options[:title]  || DEFAULT_TITLE

      self.timer        = Timer.new(options)
      self.progressable = Progress.new(options)

      self.bar          = Components::Bar.new(options.merge(:progress => progressable))
      self.percentage   = Components::Percentage.new(:progress => progressable)
      self.rate         = Components::Rate.new(options.merge(:timer => timer, :progress => progressable))
      self.time         = Components::Time.new(options.merge(:timer => timer, :progress => progressable))

      self.output       = Output.new(options.merge(:bar => self, :timer => timer))

      start :at => options[:starting_at] if autostart
    end

    def start(options = {})
      clear

      output.with_update do
        progressable.start(options)
        timer.start
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
      output.with_update do
        progressable.finish
        timer.stop
      end unless finished?
    end

    def pause
      output.with_update { timer.pause } unless paused?
    end

    def stop
      output.with_update { timer.stop } unless stopped?
    end

    def resume
      output.with_update { timer.resume } if stopped?
    end

    def reset
      output.with_update do
        progressable.reset
        timer.reset
      end
    end

    def stopped?
      timer.stopped? || finished?
    end

    alias :paused? :stopped?

    def finished?
      progressable.finished?
    end

    def started?
      timer.started? && progressable.started?
    end

    def progress_mark=(mark)
      output.with_update { bar.progress_mark = mark }
    end

    def remainder_mark=(mark)
      output.with_update { bar.remainder_mark = mark }
    end

    def title=(title)
      if output.tty?
        output.with_update { @title = title }
      end
    end

    def progress
      progressable.progress
    end

    def total
      progressable.total
    end

    def clear
      output.clear
    end

    def refresh
      output.update
    end

    def log(string)
      output.log(string)
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
      @format    = (other || DEFAULT_FORMAT_STRING)
    end

    def formatter
      @formatter ||= ProgressBar::Format::Base.new(@format)
    end

  protected

    attr_accessor :output,
                  :timer,
                  :progressable,
                  :bar,
                  :percentage,
                  :rate,
                  :time

    def update_progress(*args)
      output.with_update do
        progressable.send(*args)
        timer.stop if progressable.finished?
      end
    end
  end
end
