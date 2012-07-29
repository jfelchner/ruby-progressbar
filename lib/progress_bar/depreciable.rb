class ProgressBar
  module Depreciable
    DEPRECATION_DATE = "June 30th, 2013"

    def backwards_compatible_args_to_options_conversion(args)
      options = {}

      if args.size > 1
        puts 'DEPRECATION WARNING: Creating Progress Bars in this way has been deprecated and will be removed on or after June 30th, 2013.  Please update your code to use the new initializer syntax found here: https://github.com/jfelchner/ruby-progressbar.'
        options[:title]  = args[0]
        options[:total]  = args[1]
        options[:output] = args[2]
      else
        options = args[0]
      end

      options
    end

    def inc
      method_deprecation_message 'inc', 'increment'

      increment
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

  private

    def method_deprecation_message(old_item, new_item = '')
      message_has_not_been_shown?(old_item) do
        replacement_message = new_item.empty? ? 'There will be no replacement.' : "Please use ##{new_item} instead."
        puts "DEPRECATION WARNING: ##{old_item} will be removed on or after #{DEPRECATION_DATE}. #{replacement_message}"
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
