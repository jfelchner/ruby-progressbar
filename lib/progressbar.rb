# This file is provided for standardization purposes only.
#
# This gem didn't follow standard Ruby naming conventions and therefore, both `ruby-progressbar.rb` and `progressbar.rb` are needed.
# `ruby-progressbar.rb` because the gem name should match the filename under `lib` and `progressbar.rb` because this gem was copied
# directly from another gem and wasn't properly modified.  There are other applications which require this file.
#
puts 'DEPRECATION WARNING: This file will be removed on or after October 30th, 2012.  You should modify your Gemfiles and/or require lines to utilize the new syntax here: https://github.com/jfelchner/ruby-progressbar.'
require File.join(File.dirname(__FILE__), 'ruby-progressbar')
