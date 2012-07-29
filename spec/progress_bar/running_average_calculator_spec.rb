require 'spec_helper'

describe ProgressBar::RunningAverageCalculator do
  describe '.calculate' do
    it 'calculates properly' do
      ProgressBar::RunningAverageCalculator.calculate(4.5,  12,  0.9).should be_within(0.001).of  11.25
      ProgressBar::RunningAverageCalculator.calculate(8.2,  51,  0.3).should be_within(0.001).of  21.04
      ProgressBar::RunningAverageCalculator.calculate(41.8, 100, 0.41).should be_within(0.001).of 65.662
    end
  end
end
