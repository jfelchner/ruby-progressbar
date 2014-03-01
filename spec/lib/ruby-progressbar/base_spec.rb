require 'spec_helper'
require 'stringio'

describe ProgressBar::Base do
  let(:output) do
    StringIO.new('', 'w+').tap do |io|
      io.stub(:tty?).and_return true
    end
  end

  let(:non_tty_output) do
    StringIO.new('', 'w+').tap do |io|
      io.stub(:tty?).and_return false
    end
  end

  let(:progressbar) { ProgressBar::Base.new(:output => output, :length => 80, :throttle_rate => 0.0) }

  context 'when the terminal width is shorter than the string being output' do
    it 'can properly handle outputting the bar when the length changes on the fly to less than the minimum width' do
      progressbar = ProgressBar::Base.new(:output => output, :title => 'a' * 25, :format => '%t%B', :throttle_rate => 0.0)

      allow(progressbar).to receive(:terminal_width).
                            and_return 30

      progressbar.start

      allow(progressbar).to receive(:terminal_width).
                            and_return 20

      progressbar.increment

      output.rewind
      output.read.should match /\raaaaaaaaaaaaaaaaaaaaaaaaa     \r\s+\raaaaaaaaaaaaaaaaaaaaaaaaa\r\z/
    end

    context 'and the bar length is calculated' do
      it 'returns the proper string' do
        progressbar = ProgressBar::Base.new(:output => output, :title => ('*' * 21), :starting_at => 5, :total => 10, :autostart => false)

        allow(progressbar).to receive(:terminal_width).
                              and_return 20

        progressbar.to_s('%t%w').should eql '*********************'
      end
    end

    context 'and the incomplete bar length is calculated' do
      it 'returns the proper string' do
        progressbar = ProgressBar::Base.new(:output => output, :title => ('*' * 21), :autostart => false)

        allow(progressbar).to receive(:terminal_width).
                              and_return 20

        progressbar.to_s('%t%i').should eql '*********************'
      end

      it 'returns the proper string' do
        progressbar = ProgressBar::Base.new(:output => output, :title => ('*' * 21), :starting_at => 5, :total => 10, :autostart => false)

        allow(progressbar).to receive(:terminal_width).
                              and_return 20

        progressbar.to_s('%t%i').should eql '*********************'
      end
    end

    context 'and the full bar length is calculated (but lacks the space to output the entire bar)' do
      it 'returns the proper string' do
        progressbar = ProgressBar::Base.new(:output => output, :title => ('*' * 19), :starting_at => 5, :total => 10, :autostart => false)

        allow(progressbar).to receive(:terminal_width).
                              and_return 20

        progressbar.to_s('%t%B').should eql '******************* '
      end

      it 'returns the proper string' do
        progressbar = ProgressBar::Base.new(:output => output, :title => ('*' * 19), :starting_at => 5, :total => 10, :autostart => false)

        allow(progressbar).to receive(:terminal_width).
                              and_return 20

        progressbar.to_s('%t%w%i').should eql '******************* '
      end
    end
  end

  context 'when a new bar is created' do
    context 'and no options are passed' do
      let(:progressbar) { ProgressBar::Base.new  }

      describe '#title' do
        it 'returns the default title' do
          progressbar.send(:title).to_s.should eql ProgressBar::Base::DEFAULT_TITLE
        end
      end

      describe '#output' do
        it 'returns the default output stream' do
          progressbar.send(:output).should eql ProgressBar::Base::DEFAULT_OUTPUT_STREAM
        end
      end

      describe '#length' do
        context 'when the RUBY_PROGRESS_BAR_LENGTH environment variable exists' do
          before  { ENV['RUBY_PROGRESS_BAR_LENGTH'] = '44' }
          after   { ENV['RUBY_PROGRESS_BAR_LENGTH'] = nil }

          it 'returns the length of the environment variable as an integer' do
            progressbar = ProgressBar::Base.new
            progressbar.send(:length).should eql 44
          end
        end

        context 'when the RUBY_PROGRESS_BAR_LENGTH environment variable does not exist' do
          before  { ENV['RUBY_PROGRESS_BAR_LENGTH'] = nil }

          context 'but the length option was passed in' do
            it 'returns the length specified in the option' do
              progressbar = ProgressBar::Base.new(:length => 88)
              progressbar.send(:length).should eql 88
            end
          end

          context 'and no length option was passed in' do
            it 'returns the width of the terminal if it is a Unix environment' do
              progressbar.stub(:terminal_width).and_return(99)
              progressbar.send(:reset_length)
              progressbar.send(:length).should eql 99
            end

            it 'returns 80 if it is not a Unix environment' do
              progressbar.stub(:unix?).and_return(false)
              progressbar.send(:reset_length)
              progressbar.send(:length).should eql 80
            end
          end
        end
      end
    end

    context 'and options are passed' do
      let(:progressbar) { ProgressBar::Base.new(:title => 'We All Float', :total => 12, :output => STDOUT, :progress_mark => 'x', :length => 88, :starting_at => 5)  }

      describe '#title' do
        it 'returns the overridden title' do
          progressbar.send(:title).to_s.should eql 'We All Float'
        end
      end

      describe '#output' do
        it 'returns the overridden output stream' do
          progressbar.send(:output).should eql STDOUT
        end
      end

      describe '#length' do
        it 'returns the overridden length' do
          progressbar.send(:length).should eql 88
        end
      end
    end

    context 'if the bar was started 4 minutes ago' do
      before do
        Timecop.travel(-240) do
          progressbar.start
        end
      end

      context 'and within 2 minutes it was halfway done' do
        before do
          Timecop.travel(-120) do
            50.times { progressbar.increment }
          end
        end

        describe '#finish' do
          before do
            Timecop.travel(-120) do
              progressbar.finish
            end
          end

          it 'completes the bar' do
            output.rewind
            output.read.should match /Progress: \|#{'=' * 68}\|\n/
          end

          it 'shows the elapsed time instead of the estimated time since the bar is completed' do
            progressbar.to_s('%e').should eql 'Time: 00:02:00'
          end

          it 'calculates the elapsed time to 00:02:00' do
            progressbar.to_s('%a').should eql 'Time: 00:02:00'
          end
        end
      end
    end

    context 'which includes ANSI SGR codes in the format string' do
      it 'properly calculates the length of the bar by removing the long version of the ANSI codes from the calculated length' do
        @color_code     = "\e[0m\e[32m\e[7m\e[1m"
        @reset_code     = "\e[0m"
        @progress_mark  = "#{@color_code} #{@reset_code}"
        progressbar    = ProgressBar::Base.new(:format        => "#{@color_code}Processing... %b%i#{@reset_code}#{@color_code} %p%%#{@reset_code}",
                                                :progress_mark => @progress_mark,
                                                :output        => output,
                                                :length        => 24,
                                                :starting_at   => 3,
                                                :total         => 6,
                                                :throttle_rate => 0.0)

        progressbar.increment
        progressbar.increment

        output.rewind
        output.read.should include "#{@color_code}Processing... #{@progress_mark * 3}#{' ' * 3}#{@reset_code}#{@color_code} 50%#{@reset_code}\r#{@color_code}Processing... #{@progress_mark * 3}#{' ' * 3}#{@reset_code}#{@color_code} 66%#{@reset_code}\r#{@color_code}Processing... #{@progress_mark * 4}#{' ' * 2}#{@reset_code}#{@color_code} 83%#{@reset_code}\r"
      end

      it 'properly calculates the length of the bar by removing the short version of the ANSI codes from the calculated length' do
        @color_code     = "\e[0;32;7;1m"
        @reset_code     = "\e[0m"
        @progress_mark  = "#{@color_code} #{@reset_code}"
        progressbar    = ProgressBar::Base.new(:format        => "#{@color_code}Processing... %b%i#{@reset_code}#{@color_code} %p%%#{@reset_code}",
                                                :progress_mark => @progress_mark,
                                                :output        => output,
                                                :length        => 24,
                                                :starting_at   => 3,
                                                :total         => 6,
                                                :throttle_rate => 0.0)

        progressbar.increment
        progressbar.increment

        output.rewind
        output.read.should include "#{@color_code}Processing... #{@progress_mark * 3}#{' ' * 3}#{@reset_code}#{@color_code} 50%#{@reset_code}\r#{@color_code}Processing... #{@progress_mark * 3}#{' ' * 3}#{@reset_code}#{@color_code} 66%#{@reset_code}\r#{@color_code}Processing... #{@progress_mark * 4}#{' ' * 2}#{@reset_code}#{@color_code} 83%#{@reset_code}\r"
      end
    end

    context 'for a TTY enabled device' do
      it 'can log messages' do
        progressbar = ProgressBar::Base.new(:output => output, :length => 20, :starting_at => 3, :total => 6, :throttle_rate => 0.0)
        progressbar.increment
        progressbar.log 'We All Float'
        progressbar.increment

        output.rewind
        output.read.should include "Progress: |====    |\rProgress: |=====   |\r                    \rWe All Float\nProgress: |=====   |\rProgress: |======  |\r"
      end
    end

    context 'for a non-TTY enabled device' do
      it 'can log messages' do
        progressbar = ProgressBar::Base.new(:output => non_tty_output, :length => 20, :starting_at => 4, :total => 6, :throttle_rate => 0.0)
        progressbar.increment
        progressbar.log 'We All Float'
        progressbar.increment
        progressbar.finish

        non_tty_output.rewind
        non_tty_output.read.should include "We All Float\nProgress: |========|\n"
      end

      it 'can output the bar properly so that it does not spam the screen' do
        progressbar = ProgressBar::Base.new(:output => non_tty_output, :length => 20, :starting_at => 0, :total => 6, :throttle_rate => 0.0)

        6.times { progressbar.increment }

        non_tty_output.rewind
        non_tty_output.read.should eql "\n\nProgress: |========|\n"
      end

      it 'can output the bar properly if finished in the middle of its progress' do
        progressbar = ProgressBar::Base.new(:output => non_tty_output, :length => 20, :starting_at => 0, :total => 6, :throttle_rate => 0.0)

        3.times { progressbar.increment }

        progressbar.finish

        non_tty_output.rewind
        non_tty_output.read.should eql "\n\nProgress: |========|\n"
      end

      it 'can output the bar properly if stopped in the middle of its progress' do
        progressbar = ProgressBar::Base.new(:output => non_tty_output, :length => 20, :starting_at => 0, :total => 6, :throttle_rate => 0.0)

        3.times { progressbar.increment }

        progressbar.stop

        non_tty_output.rewind
        non_tty_output.read.should eql "\n\nProgress: |====\n"
      end
    end
  end

  context 'when a bar is about to be completed' do
    let(:progressbar) { ProgressBar::Base.new(:starting_at => 5, :total => 6, :output => output, :length => 20) }

    context 'and it is incremented' do
      before { progressbar.increment }

      it 'registers as being "finished"' do
        progressbar.should be_finished
      end

      it 'prints a new line' do
        output.rewind
        output.read.end_with?("\n").should be_true
      end

      it 'does not continue to print bars if finish is subsequently called' do
        progressbar.finish

        output.rewind
        output.read.should end_with "                    \rProgress: |======  |\rProgress: |========|\n"
      end
    end
  end

  context 'when a bar has an unknown amount to completion' do
    let(:progressbar) { ProgressBar::Base.new(:total => nil, :output => output, :length => 80, :unknown_progress_animation_steps => ['=--', '-=-', '--=']) }

    it 'is represented correctly' do
      progressbar.to_s('%i').should eql '=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=-'
    end

    it 'is represented after being incremented once' do
      progressbar.increment
      progressbar.to_s('%i').should eql '-=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--='
    end

    it 'is represented after being incremented twice' do
      progressbar.increment
      progressbar.increment
      progressbar.to_s('%i').should eql '--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--'
    end

    it 'displays the proper ETA' do
      progressbar.increment

      progressbar.to_s('%i%e').should eql '-=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=- ETA: ??:??:??'
      progressbar.to_s('%i%E').should eql '-=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=- ETA: ??:??:??'
    end
  end

  context 'when a bar is started' do
    let(:progressbar) { ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => output, :length => 80, :throttle_rate  => 0.0) }

    context 'and it is incremented any number of times' do
      before { 10.times { progressbar.increment } }

      describe '#progress_mark=' do
        it 'changes the mark used to represent progress and updates the output' do
          progressbar.progress_mark = 'x'

          output.rewind
          output.read.should match /\rProgress: \|xxxxxx#{' ' * 62}\|\r\z/
        end
      end

      describe '#remainder_mark=' do
        it 'changes the mark used to represent the remaining part of the bar and updates the output' do
          progressbar.remainder_mark = 'x'

          output.rewind
          output.read.should match /\rProgress: \|======#{'x' * 62}\|\r\z/
        end
      end

      describe '#title=' do
        it 'changes the title used to represent the items being progressed and updates the output' do
          progressbar.title = 'Items'

          output.rewind
          output.read.should match /\rItems: \|=======#{' ' * 64}\|\r\z/
        end
      end

      describe '#reset' do
        before { progressbar.reset }

        it 'resets the bar back to the starting value' do
          output.rewind
          output.read.should match /\rProgress: \|#{' ' * 68}\|\r\z/
        end
      end

      describe '#stop' do
        before { progressbar.stop }

        it 'forcibly halts the bar wherever it is and cancels it' do
          output.rewind
          output.read.should match /\rProgress: \|======#{' ' * 62}\|\n\z/
        end

        it 'does not output the bar multiple times if the bar is already stopped' do
          output.rewind
          progressbar.stop
          output.rewind

          output.read.should_not start_with "Progress: |======#{' ' * 62}|"
        end
      end

      describe '#resume' do
        it 'does not output the bar multiple times' do
          output.rewind
          progressbar.resume
          output.rewind

          output.read.should_not start_with "Progress: |======#{' ' * 62}|"
        end
      end
    end
  end

  context 'when a bar is started from 10/100' do
    let(:progressbar) { ProgressBar::Base.new(:starting_at => 10, :total => 100, :output => output, :length => 112) }

    context 'and it is incremented any number of times' do
      before { 10.times { progressbar.increment } }

      describe '#reset' do
        before { progressbar.reset }

        it 'resets the bar back to the starting value' do
          output.rewind
          output.read.should match /\rProgress: \|==========#{' ' * 90}\|\r\z/
        end
      end
    end
  end

  describe '#clear' do
    it 'clears the current terminal line and/or bar text' do
      progressbar.clear

      output.rewind
      output.read.should match /^#{progressbar.send(:clear_string)}/
    end
  end

  describe '#start' do
    it 'clears the current terminal line' do
      progressbar.start

      output.rewind
      output.read.should match /^#{progressbar.send(:clear_string)}/
    end

    it 'prints the bar for the first time' do
      progressbar.start

      output.rewind
      output.read.should match /Progress: \|                                                                    \|\r\z/
    end

    it 'prints correctly if passed a position to start at' do
      progressbar.start(:at => 20)

      output.rewind
      output.read.should match /Progress: \|=============                                                       \|\r\z/
    end
  end

  context 'when the bar has not been completed' do
    let(:progressbar) { ProgressBar::Base.new(:length => 112, :starting_at => 0, :total => 50, :output => output, :throttle_rate => 0.0)  }

    describe '#increment' do
      before { progressbar.increment }

      it 'displays the bar with the correct formatting' do
        output.rewind
        output.read.should match /Progress: \|==                                                                                                  \|\r\z/
      end
    end
  end

  context 'when a new bar is created with a specific format' do
    context '#format' do
      let(:progressbar) { ProgressBar::Base.new(:format => '%B %p%%') }

      context 'if called with no arguments' do
        before { progressbar.format }

        it 'resets the format back to the default' do
          progressbar.to_s.should match /^Progress: \|\s+\|\z/
        end
      end

      context 'if called with a specific format string' do
        before { progressbar.format '%t' }

        it 'sets it as the new format for the bar' do
          progressbar.to_s.should match /^Progress\z/
        end
      end
    end

    context '#to_s' do
      it 'displays the title when passed the "%t" format flag' do
        progressbar.to_s('%t').should match /^Progress\z/
      end

      it 'displays the title when passed the "%T" format flag' do
        progressbar.to_s('%T').should match /^Progress\z/
      end

      it 'displays the bar when passed the "%B" format flag (including empty space)' do
        progressbar = ProgressBar::Base.new(:length => 100, :starting_at => 20)
        progressbar.to_s('%B').should match /^#{'=' * 20}#{' ' * 80}\z/
      end

      it 'displays the bar when passed the combined "%b%i" format flags' do
        progressbar = ProgressBar::Base.new(:length => 100, :starting_at => 20)
        progressbar.to_s('%b%i').should match /^#{'=' * 20}#{' ' * 80}\z/
      end

      it 'displays the bar when passed the "%b" format flag (excluding empty space)' do
        progressbar = ProgressBar::Base.new(:length => 100, :starting_at => 20)
        progressbar.to_s('%b').should match /^#{'=' * 20}\z/
      end

      it 'displays the incomplete space when passed the "%i" format flag' do
        progressbar = ProgressBar::Base.new(:length => 100, :starting_at => 20)
        progressbar.to_s('%i').should match /^#{' ' * 80}\z/
      end

      it 'displays the bar when passed the "%w" format flag' do
        progressbar = ProgressBar::Base.new(:output => output, :length => 100, :starting_at => 0)

        progressbar.to_s('%w').should match /^\z/
        4.times { progressbar.increment }
        progressbar.to_s('%w').should match /^====\z/
        progressbar.increment
        progressbar.to_s('%w').should match /^= 5 =\z/
        5.times { progressbar.increment }
        progressbar.to_s('%w').should match /^=== 10 ===\z/
        progressbar.decrement
        progressbar.to_s('%w').should match /^=== 9 ===\z/
        91.times { progressbar.increment }
        progressbar.to_s('%w').should match /^#{'=' * 47} 100 #{'=' * 48}\z/
      end

      it 'calculates the remaining negative space properly with an integrated percentage bar of 0 percent' do
        progressbar = ProgressBar::Base.new(:output => output, :length => 100, :total => 200, :starting_at => 0)

        progressbar.to_s('%w%i').should match /^\s{100}\z/
        9.times { progressbar.increment }
        progressbar.to_s('%w%i').should match /^====\s{96}\z/
        progressbar.increment
        progressbar.to_s('%w%i').should match /^= 5 =\s{95}\z/
      end

      it 'displays the current capacity when passed the "%c" format flag' do
        progressbar = ProgressBar::Base.new(:output => output, :starting_at => 0)

        progressbar.to_s('%c').should match /^0\z/
        progressbar.increment
        progressbar.to_s('%c').should match /^1\z/
        progressbar.decrement
        progressbar.to_s('%c').should match /^0\z/
      end

      it 'displays the total capacity when passed the "%C" format flag' do
        progressbar = ProgressBar::Base.new(:total => 100)

        progressbar.to_s('%C').should match /^100\z/
      end

      it 'displays the percentage complete when passed the "%p" format flag' do
        progressbar = ProgressBar::Base.new(:starting_at => 33, :total => 200)

        progressbar.to_s('%p').should match /^16\z/
      end

      it 'displays the percentage complete when passed the "%P" format flag' do
        progressbar = ProgressBar::Base.new(:starting_at => 33, :total => 200)

        progressbar.to_s('%P').should match /^16.50\z/
      end

      it 'displays only up to 2 decimal places when using the "%P" flag' do
        progressbar = ProgressBar::Base.new(:starting_at => 66, :total => 99)

        progressbar.to_s('%P').should match /^66.66\z/
      end

      it 'displays a literal percent sign when using the "%%" flag' do
        progressbar = ProgressBar::Base.new(:starting_at => 66, :total => 99)

        progressbar.to_s('%%').should match /^%\z/
      end

      it 'displays a literal percent sign when using the "%%" flag' do
        progressbar = ProgressBar::Base.new(:starting_at => 66, :total => 99)

        progressbar.to_s('%%').should match /^%\z/
      end

      # Autostarting for now.  This will be applicable later.
      # context "when called before #start" do
        # it "displays unknown time elapsed when using the %a flag" do
          # progressbar.to_s('%a').should match /^Time: --:--:--\z/
        # end
      # end

      context 'when called after #start' do
        before do
          Timecop.travel(-3723) do
            progressbar.start
          end
        end

        context 'and the bar is reset' do
          before { progressbar.reset }

          it 'displays "??:??:??" until finished when passed the %e flag' do
            progressbar.to_s('%a').should match /^Time: --:--:--\z/
          end
        end

        it 'displays the time elapsed when using the "%a" flag' do
          progressbar.to_s('%a').should match /^Time: 01:02:03\z/
        end
      end

      context 'when called before #start' do
        it 'displays unknown time until finished when passed the "%e" flag' do
          progressbar = ProgressBar::Base.new
          progressbar.to_s('%e').should match /^ ETA: \?\?:\?\?:\?\?\z/
        end
      end

      context 'when called after #start' do
        let(:progressbar) do
          Timecop.travel(-3723) do
            progressbar = ProgressBar::Base.new(:starting_at => 0, :output => output, :smoothing => 0.0)
            progressbar.start
            progressbar.progress = 50
            progressbar
          end
        end

        context 'and the bar is reset' do
          before { progressbar.reset }

          it 'displays "??:??:??" until finished when passed the "%e" flag' do
            progressbar.to_s('%e').should match /^ ETA: \?\?:\?\?:\?\?\z/
          end
        end

        it 'displays the estimated time remaining when using the "%e" flag' do
          progressbar.to_s('%e').should match /^ ETA: 01:02:03\z/
        end
      end

      context 'when it could take 100 hours or longer to finish' do
        let(:progressbar) do
          Timecop.travel(-120000) do
            progressbar = ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => output, :smoothing => 0.0)
            progressbar.start
            progressbar.progress = 25
            progressbar
          end
        end

        it 'displays "> 4 Days" until finished when passed the "%E" flag' do
          progressbar.to_s('%E').should match /^ ETA: > 4 Days\z/
        end

        it 'displays "??:??:??" until finished when passed the "%e" flag' do
          progressbar.to_s('%e').should match /^ ETA: \?\?:\?\?:\?\?\z/
        end

        it 'displays the exact estimated time until finished when passed the "%f" flag' do
          progressbar.to_s('%f').should match /^ ETA: 100:00:00\z/
        end
      end
    end
  end

  context 'when the bar is started after having total set to 0' do
    let(:progressbar) { ProgressBar::Base.new(:output => output, :autostart => false) }

    it 'does not throw an error' do
      progressbar.total = 0

      expect { progressbar.start }.not_to raise_error
    end
  end

  context 'when the bar has no items to process' do
    context 'and it has not been started' do
      let(:progressbar) { ProgressBar::Base.new(:started_at => 0, :total => 0, :autostart => false, :smoothing => 0.0, :format => ' %c/%C |%w>%i| %e ', :output => output) }

      it 'does not throw an error if told to stop' do
        progressbar.stop

        expect { progressbar.start }.not_to raise_error
      end
    end
  end
end
