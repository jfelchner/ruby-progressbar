require 'ruby-progressbar/length_calculator'
require 'ruby-progressbar/running_average_calculator'
require 'ruby-progressbar/formatter'
require 'ruby-progressbar/components'
require 'ruby-progressbar/format'
require 'ruby-progressbar/base'

class ProgressBar
  def self.create(*args)
    ProgressBar::Base.new *args
  end
end
