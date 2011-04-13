#
# Ruby/ProgressBar - a text progress bar library
#
# Copyright (C) 2001-2005 Satoru Takabayashi <satoru@namazu.org>
#     All rights reserved.
#     This is free software with ABSOLUTELY NO WARRANTY.
#
# You can redistribute it and/or modify it under the terms
# of Ruby's license.
#

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

    def current
      @bar.current
    end

    def total
      @bar.total
    end

    def percentage
      @bar.percentage_completed
    end

    def percentage_with_precision
      @bar.percentage_completed_with_precision
    end

    def elapsed_time
      @elapsed_time
    end

    def estimated_time
      @estimated_time.out_of_bounds_time_format = nil
      @estimated_time
    end

    def estimated_time_with_unknown_oob
      @estimated_time.out_of_bounds_time_format = :unknown
      @estimated_time
    end

    def estimated_time_with_friendly_oob
      @estimated_time.out_of_bounds_time_format = :friendly
      @estimated_time
    end

    def bar(length)
      @bar.to_s(length)
    end

    def reversed_bar(length)
      @bar.reverse unless @bar.reversed?
      @bar.to_s(length)
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

      # def percentage
        # progress_as_percentage(@current)
      # end

      # def inspect
        # "#<ProgressBar:#{@current}/#{@total}>"
      # end

      # private
      # def text
        # arguments = @format_arguments.map do |method|
          # method = sprintf("fmt_%s", method)
          # send(method)
        # end

        # sprintf(@format, *arguments) + eol
        # "PROGRESS BAR!!#{eol}"
      # end

      # def eol
        # if finished? then "\n" else "\r" end
      # end

      # def percentage_changed?
        # Use "!=" instead of ">" to support negative changes
        # current_percentage != previous_percentage
      # end

      # def time_elapsed?
        # Time.now - @previous_time >= 1
      # end

      # alias :current_percentage, :percentage

      # def previous_percentage
        # progress_as_percentage(@previous)
      # end

      # def progress_as_percentage(progress)
        # (progress * 100 / @total).to_i
      # end

      # def progress_range
        # 0..@total
      # end
  end
end
