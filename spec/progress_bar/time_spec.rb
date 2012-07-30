require 'spec_helper'

describe ProgressBar::Time do
  describe '#now' do
    it 'is the current time' do
      now = Time.utc(2011, 1, 1, 12, 0 ,0)

      Timecop.freeze(now) do
        ProgressBar::Time.now.should eql now
      end
    end
  end
end
