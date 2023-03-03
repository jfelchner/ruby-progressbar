require 'spec_helper'
require 'ruby-progressbar/calculators/smoothed_average'

class    ProgressBar
module   Calculators
describe SmoothedAverage do
  it 'can properly calculate a projector' do
    first_projection = SmoothedAverage.calculate(4.5,  12,  0.1)
    expect(first_projection).to be_within(0.001).of 11.25

    second_projection = SmoothedAverage.calculate(8.2,  51,  0.7)
    expect(second_projection).to be_within(0.001).of 21.04

    third_projection = SmoothedAverage.calculate(41.8, 100, 0.59)
    expect(third_projection).to be_within(0.001).of 65.662
  end

  describe '#strength' do
    it 'allows the default strength to be overridden' do
      projector = SmoothedAverage.new(:strength => 0.3)

      expect(projector.strength).to be 0.3
    end

    it 'has a default strength' do
      expect(SmoothedAverage.new.strength).to be 0.1
    end
  end
end
end
end
