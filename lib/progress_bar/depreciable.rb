class ProgressBar
  module Depreciable
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
      puts 'DEPRECATION WARNING: #inc will be removed on or after June 30th, 2013.  Please use #increment'

      increment
    end

    def set(new_value)
      puts 'DEPRECATION WARNING: #set will be removed on or after June 30th, 2013.  Please use #progress='

      progress = new_value
    end

    def halt
      puts 'DEPRECATION WARNING: #halt will be removed on or after June 30th, 2013.  Please use #stop'

      stop
    end

    def bar_mark=(mark)
      puts 'DEPRECATION WARNING: Updating the mark in this way has been deprecated and will be removed on or after June 30th, 2013.  Please use #progress_mark instead.'

      progress_mark = mark
    end
  end
end
