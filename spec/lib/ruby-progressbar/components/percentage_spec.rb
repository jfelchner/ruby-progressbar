require 'spec_helper'
require 'ruby-progressbar/components/percentage'

class    ProgressBar
module   Components
describe Percentage do
  describe '#percentage' do
    it 'returns the percentage' do
      progress   = Progress.new(:total => 10)
      percentage = Percentage.new(:progress => progress)

      progress.progress = 5

      expect(percentage.percentage).to eql '50'
    end
  end

  describe '#percentage_with_precision' do
    it 'returns the percentage' do
      progress   = Progress.new(:total => 10)
      percentage = Percentage.new(:progress => progress)

      progress.progress = 5

      expect(percentage.percentage_with_precision).to eql '50.00'
    end
  end

  describe '#justified_percentage' do
    it 'returns the percentage' do
      progress   = Progress.new(:total => 10)
      percentage = Percentage.new(:progress => progress)

      progress.progress = 5

      expect(percentage.justified_percentage).to eql ' 50'
    end
  end

  describe '#justified_percentage_with_precision' do
    it 'returns the percentage' do
      progress   = Progress.new(:total => 10)
      percentage = Percentage.new(:progress => progress)

      progress.progress = 5

      expect(percentage.justified_percentage_with_precision).to eql ' 50.00'
    end
  end
end
end
end
