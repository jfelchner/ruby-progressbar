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
      subject.running_average.should eql 0
    end
  end
end
