require 'spec_helper'
require 'timecop'

describe ProgressBar::Components::Timer do
  before { @timer = ProgressBar::Components::Timer.new }

  describe "#to_s" do
    context "when the timer hasn't been started" do
      it "displays 'Time: --:--:--'" do
        @timer.to_s.should eql "Time: --:--:--"
      end
    end

    context "when it has just been started" do
      it "displays 'Time: 00:00:00'" do
        @timer.start
        @timer.to_s.should eql 'Time: 00:00:00'
      end
    end

    context "when it was started 4 hours, 28 minutes and 13 seconds ago" do
      before do
        Timecop.travel(-16093) do
          @timer.start
        end
      end

      context "and it was stopped 32 seconds ago" do
        before do
          Timecop.travel(-32) do
            @timer.stop
          end
        end

        it "displays 'Time: 04:27:41'" do
          @timer.to_s.should eql 'Time: 04:27:41'
        end
      end

      it "displays 'Time: 04:28:13'" do
        @timer.to_s.should eql 'Time: 04:28:13'
      end
    end

    context "when it was started 4 hours, 28 minutes and 13 seconds ago" do
      it "displays 'Time: 04:28:13'" do
        Timecop.travel(-16093) do
          @timer.start
        end

        @timer.to_s.should eql 'Time: 04:28:13'
      end
    end
  end
end
