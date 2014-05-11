require 'rspectacular'

class ProgressableClass
  include ProgressBar::Components::Progressable
end

describe ProgressBar::Components::Progressable do
  subject { ProgressableClass.new }

  describe '#running_average' do
    it 'is properly calculated when progress has been made' do
      subject.running_average = 10
      subject.start :at => 0
      expect(subject.running_average).to be_zero

      subject.progress += 40
      expect(subject.running_average).to eql 36.0
    end

    it 'is always reset when the progressable is started' do
      subject.running_average = 10
      subject.start :at => 0
      expect(subject.running_average).to be_zero

      subject.start :at => 40
      expect(subject.running_average).to eql 0.0
    end
  end

  describe '#smoothing' do
    it 'can be passed in as an option to the initializer' do
      expect(ProgressableClass.new(:smoothing => 0.3).smoothing).to eql 0.3
    end

    it 'does not have to be passed in as an option to the initializer' do
      expect(ProgressableClass.new.smoothing).to eql 0.1
    end
  end

  describe '#percentage_completed' do
    it 'returns the default total if total is zero' do
      subject.total = 0

      expect(subject.percentage_completed).to eql 100
    end
  end
end
