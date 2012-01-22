module ProgressBar
  class Base
    include ProgressBar::LengthCalculator
    include ProgressBar::Formatter

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

    def inc
      puts 'DEPRECATION WARNING: #inc will be removed on or after October 30th, 2012.  Please use #increment'
      increment
    end

    def decrement
      with_progressables(:decrement)

      update
    end

    def increment
      with_progressables(:increment)

      update
    end

    def set(new_value)
      puts 'DEPRECATION WARNING: #set will be removed on or after October 30th, 2012.  Please use #progress='
      progress = new_value
    end

    def progress=(new_progress)
      with_progressables(:progress=, new_progress)
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

    def halt
      puts 'DEPRECATION WARNING: #halt will be removed on or after October 30th, 2012.  Please use #stop'
      stop
    end

    def stop
      with_timers(:stop)

      update
    end

    def stopped?
      @estimated_time.stopped? && @elapsed_time.stopped?
    end

    def resume
      with_timers(:resume)

      update
    end

    def progress_mark=(mark)
      @bar.progress_mark = mark

      update
    end

    def to_s(format_string = nil)
      format_string ||= @format_string

      format(format_string)
    end

    def inspect
      "#<ProgressBar:#{@bar.progress}/#{@bar.total}>"
    end

  private
    attr_accessor   :output

    # This will be removed on or after October 30th, 2011 and is only here to provide backward
    # compatibility with the previous versions of ruby-progressbar.
    def backwards_compatible_args_to_options_conversion(args)
      options = {}

      if args.size > 1
        puts 'DEPRECATION WARNING: Creating Progress Bars in this way has been deprecated and will be removed on or after October 30th, 2012.  Please update your code to use the new initializer syntax found here: https://github.com/jfelchner/ruby-progressbar.'
        options[:title]  = args[0]
        options[:total]  = args[1]
        options[:output] = args[2]
      else
        options = args[0]
      end
    end

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
