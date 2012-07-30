require 'spec_helper'

class UnmockedTime
  def self.now; end
end

describe ProgressBar::Time do
  describe '#now' do
    it 'calls #now on the passed in class' do
      UnmockedTime.should_receive(:now).once

      ProgressBar::Time.now(UnmockedTime)
    end
  end
end
