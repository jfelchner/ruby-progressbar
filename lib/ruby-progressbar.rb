require 'progress_bar/depreciable'
require 'progress_bar/length_calculator'
require 'progress_bar/running_average_calculator'
require 'progress_bar/formatter'
require 'progress_bar/components'
require 'progress_bar/format'
require 'progress_bar/base'

class ProgressBar
  def self.new(*args)
    puts "DEPRECATION WARNING: Calling `ProgressBar.new` is deprecated and will be removed on or after #{ProgressBar::Depreciable::DEPRECATION_DATE}.  Please use `ProgressBar.create` instead."

    create *args
  end

  def self.create(*args)
    ProgressBar::Base.new *args
  end
end
