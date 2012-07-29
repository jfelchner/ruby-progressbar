class ProgressBar
  module Depreciable
    DEPRECATION_DATE = "June 30th, 2013"

    def backwards_compatible_args_to_options_conversion(args)
      options = {}

      if args.size > 1
        puts "DEPRECATION WARNING: Creating progress bars using ProgressBar.new(title, total, output_io) has been deprecated and will be removed on or after #{DEPRECATION_DATE}.  Please use ProgressBar.create(:title => title, :total => total, :output => output_io) instead. The full list of options can be found here: https://github.com/jfelchner/ruby-progressbar."
        options[:title]  = args[0]
        options[:total]  = args[1]
        options[:output] = args[2]
      else
        options = args[0]
      end

      options
    end

    def inc(value = nil)
      if value.nil?
        method_deprecation_message 'inc', 'increment'

        increment
      else
        method_removal_message 'inc', 'Rather than passing a step increment to the new #increment method, you can simply do `my_progress_bar.progress += step`.'

        progress = progress + value.to_i
      end
    end

    def set(new_value)
      method_deprecation_message 'set', 'progress='

      progress = new_value
    end

    def halt
      method_deprecation_message 'halt', 'stop'

      stop
    end

    def bar_mark=(mark)
      method_deprecation_message 'bar_mark=', 'progress_mark='

      progress_mark = mark
    end

    def title_width
      method_removal_message 'title_width', 'The formatter is now smart enough to handle any title you use.  Set the format for the bar as described here: https://github.com/jfelchner/ruby-progressbar'
    end

    def title_width=(value)
      method_removal_message 'title_width=', 'The formatter is now smart enough to handle any title you use.  Set the format for the bar as described here: https://github.com/jfelchner/ruby-progressbar'
    end

    def start_time
      method_deprecation_message 'start_time'

      @elapsed_time.instance_variable_get(:@started_at)
    end

    def start_time=(value)
      method_removal_message 'start_time=', 'It is no longer appropriate to set the start time of the bar. Using #start, #stop, #pause and #resume all work as expected.'
    end

    def format=(value)
      method_removal_message 'format=', 'The formatter has been completely rewriten for v1.0.  Please use `#format(format_string)`.  See https://github.com/jfelchner/ruby-progressbar for all the formatting options.'
    end

    def format_arguments=(value)
      method_removal_message 'format_arguments=', 'The formatter has been completely rewriten for v1.0.  Please use `#format(format_string)`.  See https://github.com/jfelchner/ruby-progressbar for all the formatting options.'
    end

    def current
      method_deprecation_message 'current', 'progress'

      @bar.progress
    end

    def smoothing
      method_removal_message 'smoothing'
    end

    def smoothing=(value)
      method_removal_message 'smoothing=', 'This value can only be set via the options hash when creating a new progress bar like so: ProgressBar.create(:smoothing => 0.2)'
    end

    def file_transfer_mode
      method_removal_message 'file_transfer_mode', 'We will be implementing a much better file transfer progress bar in the upcoming version however it has been removed for v1.0.  If you still require this functionality, you should remain at v0.11.0'
    end

  private

    def method_deprecation_message(old_item, new_item = '')
      message_has_not_been_shown?(old_item) do
        replacement_message = new_item.empty? ? 'There will be no replacement.' : "Please use ##{new_item} instead."
        puts "DEPRECATION WARNING: ##{old_item} will be removed on or after #{DEPRECATION_DATE}. #{replacement_message}"
      end
    end

    def method_removal_message(old_item, message = '')
      message_has_not_been_shown?(old_item) do
        puts "REMOVAL WARNING: ##{old_item} has been removed. There is no replacement. #{message}"
      end
    end

    def safe_string(item)
      item.gsub('=', '_setter')
    end

    def message_has_not_been_shown?(item)
      unless instance_variable_get(:"@#{safe_string item}_deprecation_warning")
        instance_variable_set(:"@#{safe_string item}_deprecation_warning", true)

        yield
      end
    end
  end
end
