require 'forwardable'

class ProgressBar
  class Base
    extend Forwardable

    DEFAULT_TITLE = 'Progress'

    attr_accessor :title

    def_delegators :output,
                   :clear,
                   :log,
                   :refresh

    def_delegators :progressable,
                   :progress,
                   :total

    def initialize(options = {})
      self.autostart    = options.fetch(:autostart,  true)
      self.autofinish   = options.fetch(:autofinish, true)
      self.finished     = false
      self.format       = options[:format] || ProgressBar::TtyOutput::DEFAULT_FORMAT_STRING
      @title            = options[:title]  || DEFAULT_TITLE

      self.timer        = Timer.new(options)
      self.progressable = Progress.new(options)

      self.bar          = Components::Bar.new(options.merge(:progress => progressable))
      self.percentage   = Components::Percentage.new(:progress => progressable)
      self.rate         = Components::Rate.new(options.merge(:timer => timer, :progress => progressable))
      self.time         = Components::Time.new(options.merge(:timer => timer, :progress => progressable))

      self.output       = Output.detect(options.merge(:bar => self, :timer => timer))

      start :at => options[:starting_at] if autostart
    end

    def start(options = {})
      clear

      timer.start
      update_progress(:start, options)
    end

    def finish
      output.with_update do
        self.finished = true
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
        self.finished = false
        progressable.reset
        timer.reset
      end
    end

    def stopped?
      timer.stopped? || finished?
    end

    alias :paused? :stopped?

    def finished?
      finished || (autofinish && progressable.finished?)
    end

    def started?
      timer.started?
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

    def progress_mark=(mark)
      output.update_with_format_change { bar.progress_mark = mark }
    end

    def remainder_mark=(mark)
      output.update_with_format_change { bar.remainder_mark = mark }
    end

    def title=(title)
      output.update_with_format_change { @title = title }
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
      @format    = (other || ProgressBar::TtyOutput::DEFAULT_FORMAT_STRING)
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
                  :time,
                  :autostart,
                  :autofinish,
                  :finished

    def update_progress(*args)
      output.with_update do
        progressable.send(*args)
        timer.stop if finished?
      end
    end
  end
end
