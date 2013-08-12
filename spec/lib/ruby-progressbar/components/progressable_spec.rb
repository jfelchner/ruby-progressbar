require 'spec_helper'

class ProgressableClass
  include ProgressBar::Components::Progressable
end

describe ProgressBar::Components::Progressable do
  subject { ProgressableClass.new }

  describe '#running_average' do
    it 'is always reset when the progressable is started' do
      subject.running_average = 10
      subject.start :at => 0
      subject.running_average.should be_zero

      subject.start :at => 40
      subject.running_average.should eql 36.0
    end
  end

  describe '#smoothing' do
    it 'can be passed in as an option to the initializer' do
      ProgressableClass.new(:smoothing => 0.3).smoothing.should eql 0.3
    end

    it 'does not have to be passed in as an option to the initializer' do
      ProgressableClass.new.smoothing.should eql 0.1
    end
  end

  describe '#percentage_completed' do
    it 'returns the default total if total is zero' do
      subject.total = 0

      subject.percentage_completed.should eql 100
    end
  end
end
