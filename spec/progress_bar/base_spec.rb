require 'spec_helper'
require 'stringio'
require 'timecop'

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
          @progressbar.title.to_s.should eql ProgressBar::Components::Title::DEFAULT_TITLE
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
          @progressbar.title.to_s.should eql "We All Float"
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

    context "if the bar was started 4 minutes ago" do
      before do
        Timecop.travel(-240) do
          @progressbar.start
        end
      end

      context "and within 2 minutes it was halfway done" do
        before do
          Timecop.travel(-120) do
            50.times { @progressbar.increment }
          end
        end

        describe "#finish" do
          before do
            Timecop.travel(-120) do
              @progressbar.finish
            end
          end

          it "completes the bar" do
            @output_stream.rewind
            @output_stream.read.should match /Progress: \|#{"o" * 68}\|\n/
          end

          it "sets the estimated time to 00:00:00" do
            @progressbar.to_s('%e').should eql ' ETA: 00:00:00'
          end
        end
      end
    end
  end

  context "when a bar is about to be completed" do
    before do
      @progressbar = ProgressBar::Base.new(:beginning_position => 99, :total => 100, :output_stream => @output_stream, :length => 80)
      @progressbar.start
    end

    context "and it's incremented" do
      before { @progressbar.increment }

      it "registers as being 'finished'" do
        @progressbar.should be_finished
      end

      it "prints a new line" do
        @output_stream.rewind
        @output_stream.read[-1].should eql "\n"
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
      it "displays the title when passed the '%t' format flag" do
        @progressbar.to_s('%t').should match /^Progress\z/
      end

      it "displays the title when passed the '%T' format flag" do
        @progressbar.to_s('%T').should match /^Progress\z/
      end

      it "displays the bar when passed the '%b' format flag" do
        @progressbar.to_s('%b').should match /^#{" " * 80}\z/
      end

      it "displays the reversed bar when passed the '%r' format flag" do
        @progressbar = ProgressBar::Base.new(:output_stream => @output_stream, :length => 100, :beginning_position => 0)

        @progressbar.to_s('%r').should match /^#{" " * 100}\z/
        @progressbar.increment
        @progressbar.to_s('%r').should match /^#{" " * 99}o\z/
      end

      it "displays the current capacity when passed the '%c' format flag" do
        @progressbar = ProgressBar::Base.new(:output_stream => @output_stream, :beginning_position => 0)

        @progressbar.to_s('%c').should match /^0\z/
        @progressbar.increment
        @progressbar.to_s('%c').should match /^1\z/
      end

      it "displays the current capacity when passed the '%c' format flag" do
        @progressbar = ProgressBar::Base.new(:total => 100)

        @progressbar.to_s('%C').should match /^100\z/
      end

      it "displays the percentage complete when passed the '%p' format flag" do
        @progressbar = ProgressBar::Base.new(:beginning_position => 33, :total => 200)

        @progressbar.to_s('%p').should match /^16\z/
      end

      it "displays the percentage complete when passed the '%P' format flag" do
        @progressbar = ProgressBar::Base.new(:beginning_position => 33, :total => 200)

        @progressbar.to_s('%P').should match /^16.50\z/
      end

      it "displays only up to 2 decimal places when using the %P flag" do
        @progressbar = ProgressBar::Base.new(:beginning_position => 66, :total => 99)

        @progressbar.to_s('%P').should match /^66.66\z/
      end

      context "when called before #start" do
        it "displays unknown time elapsed when using the %a flag" do
          @progressbar.to_s('%a').should match /^Time: --:--:--\z/
        end
      end

      context "when called after #start" do
        it "displays the time elapsed when using the %a flag" do
          Timecop.travel(-3723) do
            @progressbar.start
          end

          @progressbar.to_s('%a').should match /^Time: 01:02:03\z/
        end
      end

      context "when called before #start" do
        it "displays unknown time until finished when passed the %e flag" do
          @progressbar = ProgressBar::Base.new
          @progressbar.to_s('%e').should match /^ ETA: \?\?:\?\?:\?\?\z/
        end
      end

      context "when called after #start" do
        it "displays the estimated time remaining when using the %e flag" do
          Timecop.travel(-3723) do
            @progressbar = ProgressBar::Base.new(:beginning_position => 49, :output_stream => @output_stream)
            @progressbar.start
          end

          @progressbar.increment
          @progressbar.to_s('%e').should match /^ ETA: 01:02:02\z/
        end
      end

      context "when it could take 100 hours or longer to finish" do
        before do
          Timecop.travel(-120000) do
            @progressbar = ProgressBar::Base.new(:beginning_position => 25, :total => 100, :output_stream => @output_stream)
            @progressbar.start
          end
        end

        it "displays '> 4 Days' until finished when passed the %E flag" do
          @progressbar.to_s('%E').should match /^ ETA: > 4 Days\z/
        end

        it "displays '??:??:??' until finished when passed the %e flag" do
          @progressbar.to_s('%e').should match /^ ETA: \?\?:\?\?:\?\?\z/
        end

        it "displays the exact estimated time until finished when passed the %f flag" do
          @progressbar.to_s('%f').should match /^ ETA: 100:00:00\z/
        end
      end
    end
  end
end
