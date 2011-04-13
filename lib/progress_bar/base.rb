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
      @estimated_time  = Components::EstimatedTimer.new(:current => @bar.current, :total => @bar.total)
      @elapsed_time    = Components::Timer.new
    end

    def clear
      @out.print clear_string
    end

    def start(options = {})
      clear

      @bar.current            = options[:at] || @bar.current
      @estimated_time.current = options[:at] || @estimated_time.current

      @estimated_time.start
      @elapsed_time.start

      update
    end

    def inc
      puts "#inc is deprecated.  Please use #increment"
      increment
    end

    def increment
      @bar.increment
      @estimated_time.increment

      update
    end

    def title
      @title
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
        "\r#{" " * length}\r"
      end

      def update
        # return if finished?

        if length_changed?
          clear
          reset_length
        end

        @out.print self.to_s + "\r"
        @out.flush
      end

      # def reset
      # end

      # def inc(step = 1)
        # set(@current + step)
      # end

      # def set(progress)
        # unless progress_range.include? progress
          # raise "#{progress} is an invalid number.  It must be between 0 and #{@total}."
        # end

        # @previous = @current
        # @current = progress
        # update
      # end

      # def finish
        # @current = @total
        # update
      # end

      # def halt
        # stop
      # end

      # def stop
        # update
      # end

      # def pause
        # update
      # end

      # def finished?
        # @current == @total
      # end

      # private
      # def eol
        # if finished? then "\n" else "\r" end
      # end
  end
end
