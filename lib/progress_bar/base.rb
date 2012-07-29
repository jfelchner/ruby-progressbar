class ProgressBar
  class Base
    include ProgressBar::LengthCalculator
    include ProgressBar::Formatter
    include ProgressBar::Depreciable

    DEFAULT_OUTPUT_STREAM     = STDOUT
    DEFAULT_FORMAT_STRING     = '%t: |%b|'
    DEFAULT_TITLE             = 'Progress'

    def initialize(*args)
      options          = args.empty? ? {} : backwards_compatible_args_to_options_conversion(args)

      self.output      = options[:output]                || DEFAULT_OUTPUT_STREAM

      @length_override = ENV['RUBY_PROGRESS_BAR_LENGTH'] || options[:length]

      @format_string   = options[:format]                || DEFAULT_FORMAT_STRING

      @title           = options[:title]                 || DEFAULT_TITLE
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

      with_progressables(:start, options)
      @elapsed_time.start

      update
    end

    def finish
      with_progressables(:finish)

      update
    end

    def finished?
      @bar.progress == @bar.total
    end

    def decrement
      with_progressables(:decrement)

      update
    end

    def increment
      with_progressables(:increment)

      update
    end

    def progress
      @bar.progress
    end

    def progress=(new_progress)
      with_progressables(:progress=, new_progress)
    end

    def total
      @bar.total
    end

    def reset
      @bar.reset
      with_timers(:reset)

      update
    end

    def pause
      with_timers(:pause)

      update
    end

    def stop
      with_timers(:stop)

      update
    end

    def stopped?
      @estimated_time.stopped? && @elapsed_time.stopped?
    end

    alias :paused? :stopped?

    def resume
      with_timers(:resume)

      update
    end

    def progress_mark=(mark)
      @bar.progress_mark = mark

      update
    end

    def title=(title)
      @title = title

      update
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
