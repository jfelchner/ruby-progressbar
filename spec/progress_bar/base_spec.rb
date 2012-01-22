require 'spec_helper'
require 'stringio'
require 'timecop'

describe ProgressBar::Base do
  before do
    @output = StringIO.new("", "w+")
    @progressbar = ProgressBar::Base.new(:output => @output, :length => 80)
  end

  context "when a new bar is created" do
    context "and no options are passed" do
      before { @progressbar = ProgressBar::Base.new }

      describe "#title" do
        it "returns the default title" do
          @progressbar.send(:title).to_s.should eql ProgressBar::Base::DEFAULT_TITLE
        end
      end

      describe "#output" do
        it "returns the default output stream" do
          @progressbar.send(:output).should eql ProgressBar::Base::DEFAULT_OUTPUT_STREAM
        end
      end

      describe "#length" do
        it "returns the width of the terminal if it's a Unix environment" do
          @progressbar.stub(:terminal_width).and_return(99)
          @progressbar.send(:reset_length) # This should be changed to use #any_instance
          @progressbar.send(:length).should eql 99
        end
      end

      describe "#length" do
        it "returns 80 if it's not a Unix environment" do
          @progressbar.stub(:unix?).and_return(false)
          @progressbar.send(:reset_length) # This should be changed to use #any_instance
          @progressbar.send(:length).should eql 80
        end
      end
    end

    context "and options are passed" do
      before { @progressbar = ProgressBar::Base.new(:title => "We All Float", :total => 12, :output => STDOUT, :progress_mark => "x", :length => 88, :starting_at => 5) }

      describe "#title" do
        it "returns the overridden title" do
          @progressbar.send(:title).to_s.should eql "We All Float"
        end
      end

      describe "#output" do
        it "returns the overridden output stream" do
          @progressbar.send(:output).should eql STDOUT
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
            @output.rewind
            @output.read.should match /Progress: \|#{"o" * 68}\|\n/
          end

          it "calculates the estimated time to 00:00:00" do
            @progressbar.to_s('%e').should eql ' ETA: 00:00:00'
          end

          it "calculates the elapsed time to 00:02:00" do
            @progressbar.to_s('%a').should eql 'Time: 00:02:00'
          end
        end
      end
    end
  end

  context "when a bar is about to be completed" do
    before do
      @progressbar = ProgressBar::Base.new(:starting_at => 99, :total => 100, :output => @output, :length => 80)
    end

    context "and it's incremented" do
      before { @progressbar.increment }

      it "registers as being 'finished'" do
        @progressbar.should be_finished
      end

      it "prints a new line" do
        @output.rewind
        @output.read[-1].should eql "\n"
      end
    end
  end

  context "when a bar is started" do
    before do
      @progressbar = ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => @output, :length => 80)
    end

    context "and it's incremented any number of times" do
      before { 10.times { @progressbar.increment } }

      describe "#reset" do
        before { @progressbar.reset }

        it "resets the bar back to the starting value" do
          @output.rewind
          @output.read.should match /\rProgress: \|#{" " * 68}\|\r\z/
        end
      end

      describe "#stop" do
        before { @progressbar.stop }

        it "forcibly halts the bar wherever it is and cancels it" do
          @output.rewind
          @output.read.should match /\rProgress: \|oooooo#{" " * 62}\|\n\z/
        end
      end
    end
  end

  context "when a bar is started from 10/100" do
    before do
      @progressbar = ProgressBar::Base.new(:starting_at => 10, :total => 100, :output => @output, :length => 112)
    end

    context "and it's incremented any number of times" do
      before { 10.times { @progressbar.increment } }

      describe "#reset" do
        before { @progressbar.reset }

        it "resets the bar back to the starting value" do
          @output.rewind
          @output.read.should match /\rProgress: \|oooooooooo#{" " * 90}\|\r\z/
        end
      end
    end
  end

  describe "#clear" do
    it "clears the current terminal line and/or bar text" do
      @progressbar.clear

      @output.rewind
      @output.read.should match /^#{@progressbar.send(:clear_string)}/
    end
  end

  describe "#start" do
    it "clears the current terminal line" do
      @progressbar.start

      @output.rewind
      @output.read.should match /^#{@progressbar.send(:clear_string)}/
    end

    it "prints the bar for the first time" do
      @progressbar.start

      @output.rewind
      @output.read.should match /Progress: \|                                                                    \|\r\z/
    end

    it "prints correctly if passed a position to start at" do
      @progressbar.start(:at => 20)

      @output.rewind
      @output.read.should match /Progress: \|ooooooooooooo                                                       \|\r\z/
    end
  end

  context "when the bar hasn't been completed" do
    before { @progressbar = ProgressBar::Base.new(:length => 112, :starting_at => 0, :total => 50, :output => @output) }

    describe "#increment" do
      before { @progressbar.increment }

      it "displays the bar with the correct formatting" do
        @output.rewind
        @output.read.should match /Progress: \|oo                                                                                                  \|\r\z/
      end
    end
  end

  context "when a new bar is created with a specific format" do
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

      it "displays the mirrored bar when passed the '%r' format flag" do
        @progressbar = ProgressBar::Base.new(:output => @output, :length => 100, :starting_at => 0)

        @progressbar.to_s('%m').should match /^#{" " * 100}\z/
        @progressbar.increment
        @progressbar.to_s('%m').should match /^#{" " * 99}o\z/
        @progressbar.decrement
        @progressbar.to_s('%m').should match /^#{" " * 100}\z/
      end

      it "displays the current capacity when passed the '%c' format flag" do
        @progressbar = ProgressBar::Base.new(:output => @output, :starting_at => 0)

        @progressbar.to_s('%c').should match /^0\z/
        @progressbar.increment
        @progressbar.to_s('%c').should match /^1\z/
        @progressbar.decrement
        @progressbar.to_s('%c').should match /^0\z/
      end

      it "displays the total capacity when passed the '%C' format flag" do
        @progressbar = ProgressBar::Base.new(:total => 100)

        @progressbar.to_s('%C').should match /^100\z/
      end

      it "displays the percentage complete when passed the '%p' format flag" do
        @progressbar = ProgressBar::Base.new(:starting_at => 33, :total => 200)

        @progressbar.to_s('%p').should match /^16\z/
      end

      it "displays the percentage complete when passed the '%P' format flag" do
        @progressbar = ProgressBar::Base.new(:starting_at => 33, :total => 200)

        @progressbar.to_s('%P').should match /^16.50\z/
      end

      it "displays only up to 2 decimal places when using the %P flag" do
        @progressbar = ProgressBar::Base.new(:starting_at => 66, :total => 99)

        @progressbar.to_s('%P').should match /^66.66\z/
      end

      # Autostarting for now.  This will be applicable later.
      # context "when called before #start" do
        # it "displays unknown time elapsed when using the %a flag" do
          # @progressbar.to_s('%a').should match /^Time: --:--:--\z/
        # end
      # end

      context "when called after #start" do
        before do
          Timecop.travel(-3723) do
            @progressbar.start
          end
        end

        context "and the bar is reset" do
          before { @progressbar.reset }

          it "displays '??:??:??' until finished when passed the %e flag" do
            @progressbar.to_s('%a').should match /^Time: --:--:--\z/
          end
        end

        it "displays the time elapsed when using the %a flag" do
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
        before do
          Timecop.travel(-3723) do
            @progressbar = ProgressBar::Base.new(:starting_at => 0, :output => @output)
            @progressbar.start
            @progressbar.progress = 50
          end
        end

        context "and the bar is reset" do
          before { @progressbar.reset }

          it "displays '??:??:??' until finished when passed the %e flag" do
            @progressbar.to_s('%e').should match /^ ETA: \?\?:\?\?:\?\?\z/
          end
        end

        it "displays the estimated time remaining when using the %e flag" do
          @progressbar.to_s('%e').should match /^ ETA: 01:02:02\z/
        end
      end

      context "when it could take 100 hours or longer to finish" do
        before do
          Timecop.travel(-120000) do
            @progressbar = ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => @output)
            @progressbar.start
            @progressbar.progress = 25
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