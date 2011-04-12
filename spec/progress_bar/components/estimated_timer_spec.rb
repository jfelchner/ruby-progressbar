require 'spec_helper'

describe ProgressBar::Components::EstimatedTimer do
  describe "#to_s" do
    context "when no progress has been made" do
      it "displays an unknown time remaining" do
        @estimated_time = ProgressBar::Components::EstimatedTimer.new(:total => 100)
        @estimated_time.to_s.should eql " ETA: ??:??:??"
      end
    end

    context "when half the progress has been made" do
      context "and it took 3:42:12 to do it" do
        it "displays 3:42:12 remaining" do
          @estimated_time = ProgressBar::Components::EstimatedTimer.new(:current => 50, :total => 100)

          Timecop.travel(-13332) do
            @estimated_time.start
          end

          @estimated_time.to_s.should eql " ETA: 03:42:12"
        end
      end
    end
  end
end
