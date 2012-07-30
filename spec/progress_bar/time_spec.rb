require 'spec_helper'

class UnmockedTime
  def self.now; end
end

describe ProgressBar::Time do
  describe '#now' do
    subject { ProgressBar::Time.now ::UnmockedTime }

    it 'will return the actual time' do
      ::UnmockedTime.should_receive(:now).once

      subject
    end
  end
end
