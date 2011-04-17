module ProgressBar
  class Base
    include ProgressBar::OptionsParser
    include ProgressBar::LengthCalculator
    include ProgressBar::Formatter

    DEFAULT_OUTPUT_STREAM     = STDERR
    DEFAULT_FORMAT_STRING     = '%t: |%b|'

    def initialize(*args)
      options          = args.empty? ? {} : backwards_compatible_args_to_options_conversion(args)

      @out             = options[:output_stream]         || DEFAULT_OUTPUT_STREAM

      @length_override = ENV['RUBY_PROGRESS_BAR_LENGTH'] || options[:length]

      @format_string   = options[:format]                || DEFAULT_FORMAT_STRING

      @title           = Components::Title.new(title_options_from(options))
      @bar             = Components::Bar.new(bar_options_from(options))
      @estimated_time  = Components::EstimatedTimer.new(:starting_at => @bar.current, :total => @bar.total)
      @elapsed_time    = Components::ElapsedTimer.new

      start
    end

    def clear
      @out.print clear_string
    end

    def start(options = {})
      clear

      @bar.start(options)
      @estimated_time.start(options)
      @elapsed_time.start

      update
    end

    def finish
      @bar.finish
      @estimated_time.finish

      update
    end

    def finished?
      @bar.current == @bar.total
    end

    def inc
      puts "DEPRECATION WARNING: #inc will be removed on or after October 30th, 2011.  Please use #increment"
      increment
    end

    def decrement
      @bar.decrement
      @estimated_time.decrement

      update
    end

    def increment
      @bar.increment
      @estimated_time.increment

      update
    end

    def set(new_value)
      puts "DEPRECATION WARNING: #set will be removed on or after October 30th, 2011.  Please use #current="
      current = new_value
    end

    def current=(new_current)
      @bar.current            = new_current
      @estimated_time.current = new_current
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
      puts "DEPRECATION WARNING: #halt will be removed on or after October 30th, 2011.  Please use #stop"
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

    def to_s(format_string = nil)
      format_string ||= @format_string

      format(format_string)
    end

    def inspect
      "#<ProgressBar:#{@bar.current}/#{@bar.total}>"
    end

    private
      attr_reader         :out

      # This will be removed on or after October 30th, 2011 and is only here to provide backward
      # compatibility with the previous versions of ruby-progressbar.
      def backwards_compatible_args_to_options_conversion(args)
        options = {}

        if args.size > 1
          puts "DEPRECATION WARNING: Creating Progress Bars in this way has been deprecated and will be removed on or after October 30th, 2011.  Please update your code to use the new initializer syntax found here: https://github.com/thekompanee/ruby-progressbar."
          options[:title]         = args[0]
          options[:total]         = args[1]
          options[:output_stream] = args[2]
        else
          options = args[0]
        end
      end

      def clear_string
        "#{" " * length}\r"
      end

      def with_timers(action)
        @estimated_time.send(action)
        @elapsed_time.send(action)
      end

      def update
        with_timers(:stop) if finished?

        if length_changed?
          clear
          reset_length
        end

        @out.print self.to_s + eol
        @out.flush
      end

      def eol
        finished? || stopped? ? "\n" : "\r"
      end
  end
end
