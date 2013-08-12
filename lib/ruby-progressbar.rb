require 'progress_bar/length_calculator'
require 'progress_bar/running_average_calculator'
require 'progress_bar/formatter'
require 'progress_bar/components'
require 'progress_bar/format'
require 'progress_bar/base'

class ProgressBar
  def self.create(*args)
    ProgressBar::Base.new *args
  end
end
