module ProgressBar
  class Base
    include ProgressBar::OptionsParser
    include ProgressBar::LengthCalculator
    include ProgressBar::Formatter

    DEFAULT_OUTPUT_STREAM     = STDERR
    DEFAULT_FORMAT_STRING     = '%t: |%b|'

    def initialize(options = {})
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
      @estimated_time.reset
      @elapsed_time.reset

      update
    end

    def pause
      @estimated_time.pause
      @elapsed_time.pause

      update
    end

    def stop
      @estimated_time.stop
      @elapsed_time.stop

      update
    end

    def stopped?
      @estimated_time.stopped? && elapsed_time.stopped?
    end

    def resume
      @estimated_time.resume
      @elapsed_time.resume

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

      def clear_string
        "#{" " * length}\r"
      end

      def stop_timers
        @estimated_time.stop
        @elapsed_time.stop
      end

      def update
        stop_timers if finished?

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
