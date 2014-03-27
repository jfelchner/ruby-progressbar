require 'rspectacular'

describe ProgressBar::RunningAverageCalculator do
  describe '.calculate' do
    it 'calculates properly' do
      expect(ProgressBar::RunningAverageCalculator.calculate(4.5,  12,  0.1)).to  be_within(0.001).of 11.25
      expect(ProgressBar::RunningAverageCalculator.calculate(8.2,  51,  0.7)).to  be_within(0.001).of 21.04
      expect(ProgressBar::RunningAverageCalculator.calculate(41.8, 100, 0.59)).to be_within(0.001).of 65.662
    end
  end
end
