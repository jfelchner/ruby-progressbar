require 'spec_helper'
require 'stringio'

describe ProgressBar::Base do
  before do
    @output_stream = StringIO.new("", "w+")
    @progressbar = ProgressBar::Base.new(:output_stream => @output_stream, :length => 80)
  end

  context "when a new bar is created" do
    context "and no options are passed" do
      before { @progressbar = ProgressBar::Base.new }

      describe "#title" do
        it "returns the default title" do
          @progressbar.title.should eql ProgressBar::Components::Title::DEFAULT_TITLE
        end
      end

      describe "#out" do
        it "returns the default output stream" do
          @progressbar.send(:out).should eql ProgressBar::Base::DEFAULT_OUTPUT_STREAM
        end
      end

      describe "#length" do
        it "returns the width of the terminal if it's a Unix environment" do
          @progressbar.stub(:terminal_width).and_return(99)
          @progressbar.send(:length).should eql 99
        end
      end

      describe "#length" do
        it "returns 80 if it's not a Unix environment" do
          @progressbar.stub(:unix?).and_return(false)
          @progressbar.send(:length).should eql 80
        end
      end
    end

    context "and options are passed" do
      before { @progressbar = ProgressBar::Base.new(:title => "We All Float", :total => 12, :output_stream => STDOUT, :progress_mark => "x", :length => 88, :beginning_position => 5) }

      describe "#title" do
        it "returns the overridden title" do
          @progressbar.title.should eql "We All Float"
        end
      end

      describe "#out" do
        it "returns the overridden output stream" do
          @progressbar.send(:out).should eql STDOUT
        end
      end

      describe "#length" do
        it "returns the overridden length" do
          @progressbar.send(:length).should eql 88
        end
      end
    end
  end

  describe "#clear" do
    it "clears the current terminal line and/or bar text" do
      @progressbar.clear

      @output_stream.rewind
      @output_stream.read.should eql @progressbar.send(:clear_string)
    end
  end

  describe "#start" do
    it "clears the current terminal line" do
      @progressbar.start

      @output_stream.rewind
      @output_stream.read.should match /^#{@progressbar.send(:clear_string)}/
    end

    it "prints the bar for the first time" do
      @progressbar.start

      @output_stream.rewind
      @output_stream.read.should match /Progress: \|                                                                    \|\r\z/
    end

    it "prints correctly if passed a position to start at" do
      @progressbar.start(:at => 20)

      @output_stream.rewind
      @output_stream.read.should match /Progress: \|ooooooooooooo                                                       \|\r\z/
    end
  end

  context "when the bar hasn't been completed" do
    before { @progressbar = ProgressBar::Base.new(:length => 112, :beginning_position => 0, :total => 50, :output_stream => @output_stream) }

    describe "#increment" do
      before { @progressbar.increment }

      it "displays the bar with the correct formatting" do
        @output_stream.rewind
        @output_stream.read.should match /Progress: \|oo                                                                                                  \|\r\z/
      end
    end
  end

  context "when a new bar is created with a specific format" do
    # %t: Left-Justified Title
    # %T: Right-Justified Title
    # %a: Elapsed (Absolute) Time
    # %e: Estimated Time (Will Fall Back To 'ETA: ??:??:??' When It Exceeds 99:59:59)
    # %E: Estimated Time (Will Fall Back To 'ETA: > 4 Days' When It Exceeds 99:59:59)
    # %f: Force Estimated Time Even When Inaccurate
    # %p: Percentage Complete (Integer)
    # %P: Percentage Complete (Float)
    # %c: Current Capacity
    # %C: Total Capacity
    # %b: Bar (Without End Caps)
    # %B: Bar (Without End Caps And With Integrated Percentage)
    # %r: Reversed Bar (Without End Caps) (Accumulates From The Right)
    # %R: Reversed Bar (Without End Caps And With Integrated Percentage)

    # All values have an absolute length with the exception of %t, %T, %b, %B, %i, %r, %R and %I.
    # The Titles will default to only being as long as their text.
    # The Bars will all occupy any space left over.  The minimum for the bars without end caps is 1.
    # The minimum for the Bars with end caps is 3.

    # To specify a specific length for the title, use the "*\d" notation.

    # Add '@' after any Estimated Time flag to make it show the Elapsed Time when finished
    context "#to_s" do
      it "displays the title when passed the '%t' format tag" do
        @progressbar.to_s('%t').should match /^Progress\z/
      end

      it "displays the title when passed the '%T' format tag" do
        @progressbar.to_s('%T').should match /^Progress\z/
      end

      it "displays the bar when passed the '%b' format tag" do
        @progressbar.to_s('%b').should match /^#{" " * 80}\z/
      end
    end
  end
end
