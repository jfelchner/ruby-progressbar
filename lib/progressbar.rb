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

class ProgressBar
  VERSION = "0.0.10"

  def initialize (title, total, out = STDERR)
    @title = title
    @total = total
    @out = out
    @terminal_width = 80
    @bar_mark = "o"
    @current = 0
    @previous = 0
    @finished_p = false
    @start_time = time_now
    @previous_time = @start_time
    @format_arguments = [:title, :percentage, :bar, :stat]
    @smoothing = 0.9
    @running_average = 0
    clear
    show
  end
  attr_reader   :title
  attr_reader   :current
  attr_reader   :total
  attr_accessor :start_time
  attr_writer   :bar_mark
  attr_writer   :title_width

  def title_width
    @title_width ||= 14
  end

  def format
    @format || "%-#{title_width}s %3d%% %s %s"
  end

  # Exponential smoothing helps keep jitter out of the time-remaining estimate.
  # The value may be anything from 0.0 to 1.0. Contrary to intuition, LOWER
  # values make the average smoother, and 1.0 is equivalent to no smoothing
  # whatsoever (the classic behavior). Default value is 0.9.
  attr_accessor :smoothing

  private
  def fmt_bar
    sprintf("|%s%s|",
            @bar_mark * bar_width,
            " " *  (@terminal_width - bar_width))
  end

  def fmt_percentage
    do_percentage
  end

  def fmt_stat
    if @finished_p then elapsed else eta end
  end

  def fmt_stat_for_file_transfer
    if @finished_p then
      sprintf("%s %s %s", bytes, transfer_rate, elapsed)
    else
      sprintf("%s %s %s", bytes, transfer_rate, eta)
    end
  end

  def fmt_title
    @title[0,(title_width - 1)] + ":"
  end

  def bar_width
    (do_percentage * @terminal_width / 100).to_i
  end

  def convert_bytes (bytes)
    if bytes < 1024
      sprintf("%6dB", bytes)
    elsif bytes < 1024 * 1000 # 1000kb
      sprintf("%5.1fKB", bytes.to_f / 1024)
    elsif bytes < 1024 * 1024 * 1000  # 1000mb
      sprintf("%5.1fMB", bytes.to_f / 1024 / 1024)
    else
      sprintf("%5.1fGB", bytes.to_f / 1024 / 1024 / 1024)
    end
  end

  def transfer_rate
    bytes_per_second = @current.to_f / (time_now - @start_time)
    sprintf("%s/s", convert_bytes(bytes_per_second))
  end

  def bytes
    convert_bytes(@current)
  end

  def format_time (t)
    if t < 0 or t.infinite? or t.nan?   # "not a number"
      '--:--:--'
    else
      t = t.to_i
      sec = t % 60
      min  = (t / 60) % 60
      hour = t / 3600
      sprintf("%02d:%02d:%02d", hour, min, sec);
    end
  end

  # ETA stands for Estimated Time of Arrival.
  def eta
    elapsed = time_now - @start_time
    eta = elapsed * @total / @running_average - elapsed;
    sprintf("ETA:  %s", format_time(eta))
  end

  def elapsed
    elapsed = time_now - @start_time
    sprintf("Time: %s", format_time(elapsed))
  end

  def eol
    if @finished_p then "\n" else "\r" end
  end

  def do_percentage
    if @total.zero?
      100
    else
      @current  * 100 / @total
    end
  end

  def get_width
    # FIXME: I don't know how portable it is.
    default_width = 80
    begin
      tiocgwinsz = 0x5413
      data = [0, 0, 0, 0].pack("SSSS")
      if @out.ioctl(tiocgwinsz, data) >= 0 then
        rows, cols, xpixels, ypixels = data.unpack("SSSS")
        cols > 0 ? cols : default_width
      else
        default_width
      end
    rescue Exception
      default_width
    end
  end

  def show
    tty? ? show_tty : show_no_tty
    @previous_time = time_now
  end

  # Print output to a tty device.
  def show_tty
    arguments = @format_arguments.map {|method|
      method = sprintf("fmt_%s", method)
      send(method)
    }
    line = sprintf(format, *arguments)

    width = get_width
    if line.length == width - 1
      @out.write(line + eol)
    elsif line.length >= width
      @terminal_width = [@terminal_width - (line.length - width + 1), 0].max
      if @terminal_width == 0 then @out.write(line + eol) else show end
    else # line.length < width - 1
      @terminal_width += width - line.length - 1
      show
    end
  end

  # Print output to a non-terminal device, such as a log file.
  # The terminal width is set to 80 columns.
  def show_no_tty
    @out.print("| " + elapsed + eol) and return if finished?

    # Draw title the first time
    if @last_bar_width.nil?
      @last_bar_width = 0
      @terminal_width = @terminal_width - fmt_title.size - elapsed.size - 4
      @out.print(fmt_title + " |")
    else
      bar_width_change = bar_width - @last_bar_width
      if bar_width_change > 0
        @out.print(@bar_mark * bar_width_change)
        @last_bar_width = bar_width
      end
    end
  end

  def show_if_needed
    if @total.zero?
      cur_percentage = 100
      prev_percentage = 0
    else
      cur_percentage  = (@current  * 100 / @total).to_i
      prev_percentage = (@previous * 100 / @total).to_i
    end

    # Use "!=" instead of ">" to support negative changes
    if cur_percentage != prev_percentage ||
        time_now - @previous_time >= 1 || @finished_p
      show
    end
  end

  def time_now
    # Ignore Timecop time mocking
    if Time.respond_to?(:now_without_mock_time)
      Time.now_without_mock_time
    # Ignore Delorean time mocking
    elsif Time.respond_to?(:now_without_delorean)
      Time.now_without_delorean
    else
      Time.now
    end
  end

  def tty?
    @out.tty?
  end

  public
  def clear
    return unless tty?
    @out.print "\r"
    @out.print(" " * (get_width - 1))
    @out.print "\r"
  end

  def finish
    @current = @previous = @running_average = @total
    @finished_p = true
    show
  end

  def finished?
    @finished_p
  end

  def file_transfer_mode
    @format_arguments = [:title, :percentage, :bar, :stat_for_file_transfer]
  end

  def format= (format)
    @format = format
  end

  def format_arguments= (arguments)
    @format_arguments = arguments
  end

  def halt
    @finished_p = true
    show
  end

  def inc (step = 1)
    set(@current + step)
  end

  def set (count)
    # Constrain input to 0 <= count <= 100
    @current = [ [count, @total].min, 0 ].max

    # Update the exponentially-smoothed average
    @running_average = @previous * @smoothing +
                       @running_average * (1.0 - @smoothing)

    # If this makes the percentage change by a tick or more, show it
    show_if_needed
    
    # Update for the next iteration
    @previous = @current
  end

  def inspect
    "#<ProgressBar:#{@current}/#{@total}>"
  end
end

class ReversedProgressBar < ProgressBar
  def do_percentage
    100 - super
  end
end
