require 'spec_helper'

describe ProgressBar::Components::EstimatedTimer do
  describe "#to_s" do
    context "when no progress has been made" do
      it "displays an unknown time remaining" do
        @estimated_time = ProgressBar::Components::EstimatedTimer.new(:total => 100)
        @estimated_time.to_s.should eql " ETA: ??:??:??"
      end
    end
  end
end
