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
      subject.running_average.should eql 40.0
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

  describe '#progress_made' do
    it 'is averaged, and relative to the starting position' do
      subject.running_average = 30
      subject.starting_position = 20
      subject.send(:progress_made).should eql 10
    end
  end
end
