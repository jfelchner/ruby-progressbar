require 'spec_helper'
require 'ruby-progressbar/calculators/smoothed_average'

class    ProgressBar
module   Calculators
describe SmoothedAverage do
  it 'can properly calculate a running average' do
    first_average = SmoothedAverage.calculate(4.5,  12,  0.1)
    expect(first_average).to be_within(0.001).of 11.25

    second_average = SmoothedAverage.calculate(8.2,  51,  0.7)
    expect(second_average).to be_within(0.001).of 21.04

    third_average = SmoothedAverage.calculate(41.8, 100, 0.59)
    expect(third_average).to be_within(0.001).of 65.662
  end
end
end
end
