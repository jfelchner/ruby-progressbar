require 'spec_helper'
require 'ruby-progressbar/calculators/smoothed_average'

class    ProgressBar
module   Calculators
describe SmoothedAverage do
  describe '.calculate' do
    it 'can properly calculate a projection' do
      first_projection = SmoothedAverage.calculate(4.5,  12,  0.1)
      expect(first_projection).to be_within(0.001).of 11.25

      second_projection = SmoothedAverage.calculate(8.2,  51,  0.7)
      expect(second_projection).to be_within(0.001).of 21.04

      third_projection = SmoothedAverage.calculate(41.8, 100, 0.59)
      expect(third_projection).to be_within(0.001).of 65.662
    end
  end

  describe '#projection' do
    it 'can properly calculate a running average' do
      projector = SmoothedAverage.new(:strength => 0.1)
      projector.start
      projector.progress = 5
      projector.progress = 12

      expect(projector.projection).to be_within(0.001).of 11.25
    end

    it 'knows the running average even when progress has been made' do
      projector = SmoothedAverage.new(:total => 50)

      projector.instance_variable_set(:@projection, 10)
      projector.start :at => 0

      expect(projector.projection).to be_zero

      projector.progress += 40

      expect(projector.projection).to be 36.0
    end

    it 'knows the running average is reset even after progress is started' do
      projector = SmoothedAverage.new(:total => 50)

      projector.instance_variable_set(:@projection, 10)
      projector.start :at => 0

      expect(projector.projection).to be_zero

      projector.start :at => 40

      expect(projector.projection).to be 0.0
    end
  end

  describe '#start' do
    it 'resets the projection' do
      projector = SmoothedAverage.new
      projector.start
      projector.progress = 10

      expect(projector.projection).not_to be_zero

      projector.start

      expect(projector.projection).to be 0.0
    end
  end

  describe '#reset' do
    it 'resets the projection' do
      projector = SmoothedAverage.new
      projector.start
      projector.progress = 10

      expect(projector.projection).not_to be_zero

      projector.reset

      expect(projector.projection).to be 0.0
    end

    it 'resets based on the starting position' do
      projector = SmoothedAverage.new(:strength => 0.1)
      projector.start(:at => 10)
      projector.progress = 20

      expect(projector.projection).not_to be_zero

      projector.reset
      projector.progress = 20

      expect(projector.projection).to be 9.0
    end
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
