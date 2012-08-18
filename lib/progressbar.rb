require 'progress_bar/depreciable'

# This file is provided for standardization purposes only.
#
# This gem didn't follow standard Ruby naming conventions and therefore, both `ruby-progressbar.rb` and `progressbar.rb` are needed.
# `ruby-progressbar.rb` because the gem name should match the filename under `lib` and `progressbar.rb` because this gem was copied
# directly from another gem and wasn't properly modified.  There are other applications which require this file.
#
puts "DEPRECATION WARNING: Requiring ruby-progressbar using `require progressbar` or `gem progressbar` has been deprecated and will be disabled on or after #{ProgressBar::Depreciable::DEPRECATION_DATE}.  Please use `require ruby-progressbar` or `gem ruby-progressbar` instead"
require File.join(File.dirname(__FILE__), 'ruby-progressbar')
