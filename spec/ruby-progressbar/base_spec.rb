require 'spec_helper'
require 'support/time'
require 'stringio'

# rubocop:disable Metrics/LineLength, Style/UnneededInterpolation
class    ProgressBar
describe Base do
  let(:output) do
    StringIO.new('', 'w+').tap do |io|
      allow(io).to receive(:tty?).and_return true
    end
  end

  let(:non_tty_output) do
    StringIO.new('', 'w+').tap do |io|
      allow(io).to receive(:tty?).and_return false
    end
  end

  it 'when the terminal width is shorter than the string being output can properly handle outputting the bar when the length changes on the fly to less than the minimum width' do
    progressbar = ProgressBar::Base.new(:output => output, :title => 'a' * 25, :format => '%t%B', :throttle_rate => 0.0)

    allow(progressbar.send(:output).send(:length_calculator)).to receive(:terminal_width)
                                                                   .and_return 30

    progressbar.start

    allow(progressbar.send(:output).send(:length_calculator)).to receive(:terminal_width)
                                                                   .and_return 20

    progressbar.increment

    output.rewind
    expect(output.read).to match(/\raaaaaaaaaaaaaaaaaaaaaaaaa     \r\s+\raaaaaaaaaaaaaaaaaaaaaaaaa\r\z/)
  end

  context 'when a new bar is created and the RUBY_PROGRESS_BAR_LENGTH environment variable exists' do
    before  { ENV['RUBY_PROGRESS_BAR_LENGTH'] = '44' }
    after   { ENV['RUBY_PROGRESS_BAR_LENGTH'] = nil }

    it 'returns the length of the environment variable as an integer' do
      progressbar = ProgressBar::Base.new
      expect(progressbar.send(:output).send(:length_calculator).send(:length)).to eql 44
    end
  end

  context 'when a new bar is created and the RUBY_PROGRESS_BAR_LENGTH environment variable does not exist' do
    before  { ENV['RUBY_PROGRESS_BAR_LENGTH'] = nil }

    it 'but the length option was passed in it returns the length specified in the option' do
      progressbar = ProgressBar::Base.new(:length => 88)
      expect(progressbar.send(:output).send(:length_calculator).send(:length)).to eql 88
    end

    it 'and no length option was passed in it returns the width of the terminal if it is a Unix environment' do
      progressbar = ProgressBar::Base.new
      allow(progressbar.send(:output).send(:length_calculator)).to receive(:terminal_width).and_return(99)
      progressbar.send(:output).send(:length_calculator).send(:reset_length)
      expect(progressbar.send(:output).send(:length_calculator).send(:length)).to eql 99
    end

    it 'and no length option was passed in it returns 80 if it is not a Unix environment' do
      progressbar = ProgressBar::Base.new(:output => output, :length => 80, :throttle_rate => 0.0)

      allow(progressbar.send(:output).send(:length_calculator)).to receive(:unix?).and_return(false)
      progressbar.send(:output).send(:length_calculator).send(:reset_length)
      expect(progressbar.send(:output).send(:length_calculator).send(:length)).to eql 80
    end
  end

  it 'and options are passed it returns the overridden title' do
    progressbar = ProgressBar::Base.new(:title => 'We All Float', :total => 12, :output => STDOUT, :progress_mark => 'x', :length => 88, :starting_at => 5)

    expect(progressbar.send(:title).to_s).to eql 'We All Float'
  end

  it 'and options are passed it returns the overridden output stream' do
    progressbar = ProgressBar::Base.new(:title => 'We All Float', :total => 12, :output => STDOUT, :progress_mark => 'x', :length => 88, :starting_at => 5)

    expect(progressbar.send(:output).send(:stream)).to eql STDOUT
  end

  it 'and options are passed it returns the overridden length' do
    progressbar = ProgressBar::Base.new(:title => 'We All Float', :total => 12, :output => STDOUT, :progress_mark => 'x', :length => 88, :starting_at => 5)

    expect(progressbar.send(:output).send(:length_calculator).send(:length)).to eql 88
  end

  it 'if the bar was started 4 minutes ago and within 2 minutes it was halfway done completes the bar' do
    progressbar = ProgressBar::Base.new(:output => output, :length => 80, :throttle_rate => 0.0)

    Timecop.travel(-240) do
      progressbar.start
    end

    Timecop.travel(-120) do
      50.times { progressbar.increment }
    end

    Timecop.travel(-120) do
      progressbar.finish
    end

    output.rewind

    expect(output.read).to match(/Progress: \|#{'=' * 68}\|\n/)
  end

  it 'which includes ANSI SGR codes in the format string it properly calculates the length of the bar by removing the long version of the ANSI codes from the calculated length' do
    @color_code    = "\e[0m\e[32m\e[7m\e[1m"
    @reset_code    = "\e[0m"
    @progress_mark = "#{@color_code} #{@reset_code}"
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
    expect(output.read).to include "#{@color_code}Processing... #{@progress_mark * 3}#{' ' * 3}#{@reset_code}#{@color_code} 50%#{@reset_code}\r#{@color_code}Processing... #{@progress_mark * 3}#{' ' * 3}#{@reset_code}#{@color_code} 66%#{@reset_code}\r#{@color_code}Processing... #{@progress_mark * 4}#{' ' * 2}#{@reset_code}#{@color_code} 83%#{@reset_code}\r"
  end

  it 'which includes ANSI SGR codes in the format string it properly calculates the length of the bar by removing the short version of the ANSI codes from the calculated length' do
    @color_code    = "\e[0;32;7;1m"
    @reset_code    = "\e[0m"
    @progress_mark = "#{@color_code} #{@reset_code}"
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
    expect(output.read).to include "#{@color_code}Processing... #{@progress_mark * 3}#{' ' * 3}#{@reset_code}#{@color_code} 50%#{@reset_code}\r#{@color_code}Processing... #{@progress_mark * 3}#{' ' * 3}#{@reset_code}#{@color_code} 66%#{@reset_code}\r#{@color_code}Processing... #{@progress_mark * 4}#{' ' * 2}#{@reset_code}#{@color_code} 83%#{@reset_code}\r"
  end

  it 'for a TTY enabled device it can log messages' do
    progressbar = ProgressBar::Base.new(:output => output, :length => 20, :starting_at => 3, :total => 6, :throttle_rate => 0.0)
    progressbar.increment
    progressbar.log 'We All Float'
    progressbar.increment

    output.rewind
    expect(output.read).to include "Progress: |====    |\rProgress: |=====   |\r                    \rWe All Float\nProgress: |=====   |\rProgress: |======  |\r"
  end

  it 'for a non-TTY enabled device it can log messages' do
    progressbar = ProgressBar::Base.new(:output => non_tty_output, :length => 20, :starting_at => 4, :total => 6, :throttle_rate => 0.0)
    progressbar.increment
    progressbar.log 'We All Float'
    progressbar.increment
    progressbar.finish

    non_tty_output.rewind
    expect(non_tty_output.read).to include "We All Float\nProgress: |========|\n"
  end

  it 'for a non-TTY enabled device it can output the bar properly so that it does not spam the screen' do
    progressbar = ProgressBar::Base.new(:output => non_tty_output, :length => 20, :starting_at => 0, :total => 6, :throttle_rate => 0.0)

    6.times { progressbar.increment }

    non_tty_output.rewind
    expect(non_tty_output.read).to eql "\n\nProgress: |========|\n"
  end

  it 'for a non-TTY enabled device it can output the bar properly if finished in the middle of its progress' do
    progressbar = ProgressBar::Base.new(:output => non_tty_output, :length => 20, :starting_at => 0, :total => 6, :throttle_rate => 0.0)

    3.times { progressbar.increment }

    progressbar.finish

    non_tty_output.rewind
    expect(non_tty_output.read).to eql "\n\nProgress: |========|\n"
  end

  it 'for a non-TTY enabled device it can output the bar properly if stopped in the middle of its progress' do
    progressbar = ProgressBar::Base.new(:output => non_tty_output, :length => 20, :starting_at => 0, :total => 6, :throttle_rate => 0.0)

    3.times { progressbar.increment }

    progressbar.stop

    non_tty_output.rewind
    expect(non_tty_output.read).to eql "\n\nProgress: |====\n"
  end

  it 'for a non-TTY enabled device it ignores changes to the title due to the fact that the bar length cannot change' do
    progressbar = ProgressBar::Base.new(:output => non_tty_output, :length => 20, :starting_at => 0, :total => 6, :throttle_rate => 0.0)

    3.times { progressbar.increment }

    progressbar.title = 'Testing'
    progressbar.stop

    non_tty_output.rewind

    expect(non_tty_output.read).to eql "\n\nProgress: |====\n"
  end

  it 'for a non-TTY enabled device it allows the title to be customized when the bar is created' do
    progressbar = ProgressBar::Base.new(:output => non_tty_output, :title => 'Custom', :length => 20, :starting_at => 0, :total => 6, :throttle_rate => 0.0)

    3.times { progressbar.increment }

    progressbar.stop

    non_tty_output.rewind

    expect(non_tty_output.read).to eql "\n\nCustom: |=====\n"
  end

  it 'when a bar is about to be completed and it is incremented it registers as being "finished"' do
    progressbar = ProgressBar::Base.new(:starting_at => 5, :total => 6, :output => output, :length => 20, :throttle_rate => 0.0)
    progressbar.increment

    expect(progressbar).to be_finished
  end

  it 'when a bar is about to be completed and it is incremented it prints a new line' do
    progressbar = ProgressBar::Base.new(:starting_at => 5, :total => 6, :output => output, :length => 20, :throttle_rate => 0.0)
    progressbar.increment

    output.rewind
    expect(output.read.end_with?("\n")).to eql true
  end

  it 'when a bar is about to be completed and it is incremented it does not continue to print bars if finish is subsequently called' do
    progressbar = ProgressBar::Base.new(:starting_at => 5, :total => 6, :output => output, :length => 20, :throttle_rate => 0.0)
    progressbar.increment
    progressbar.finish

    output.rewind
    expect(output.read).to end_with "                    \rProgress: |======  |\rProgress: |========|\n"
  end

  it 'and it is incremented it does not automatically finish' do
    progressbar = ProgressBar::Base.new(:autofinish => false, :starting_at => 5, :total => 6, :output => output, :length => 20, :throttle_rate => 0.0)
    progressbar.increment

    expect(progressbar).not_to be_finished
  end

  it 'and it is incremented it does not prints a new line' do
    progressbar = ProgressBar::Base.new(:autofinish => false, :starting_at => 5, :total => 6, :output => output, :length => 20, :throttle_rate => 0.0)
    progressbar.increment

    output.rewind

    expect(output.read.end_with?("\n")).to eql false
  end

  it 'and it is incremented it allows reset' do
    progressbar = ProgressBar::Base.new(:autofinish => false, :starting_at => 5, :total => 6, :output => output, :length => 20, :throttle_rate => 0.0)
    progressbar.increment
    progressbar.finish
    expect(progressbar).to be_finished

    progressbar.reset

    expect(progressbar).not_to be_finished
  end

  it 'and it is incremented it does prints a new line when manually finished' do
    progressbar = ProgressBar::Base.new(:autofinish => false, :starting_at => 5, :total => 6, :output => output, :length => 20, :throttle_rate => 0.0)
    progressbar.increment
    progressbar.finish
    expect(progressbar).to be_finished

    output.rewind

    expect(output.read.end_with?("\n")).to eql true
  end

  it 'and it is incremented it does not continue to print bars if finish is subsequently called' do
    progressbar = ProgressBar::Base.new(:autofinish => false, :starting_at => 5, :total => 6, :output => output, :length => 20, :throttle_rate => 0.0)
    progressbar.increment
    progressbar.finish

    output.rewind

    expect(output.read).to end_with "                    \rProgress: |======  |\rProgress: |========|\rProgress: |========|\n"
  end

  it 'when a bar is started and it is incremented any number of times changes the progress mark used to represent progress and updates the output' do
    progressbar = ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => output, :length => 80, :throttle_rate => 0.0)
    10.times { progressbar.increment }
    progressbar.progress_mark = 'x'

    output.rewind
    expect(output.read).to match(/\rProgress: \|xxxxxx#{' ' * 62}\|\r\z/)
  end

  it 'when a bar is started and it is incremented any number of times changes the remainder mark used to represent the remaining part of the bar and updates the output' do
    progressbar = ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => output, :length => 80, :throttle_rate => 0.0)
    10.times { progressbar.increment }
    progressbar.remainder_mark = 'x'

    output.rewind
    expect(output.read).to match(/\rProgress: \|======#{'x' * 62}\|\r\z/)
  end

  it 'when a bar is started and it is incremented any number of times changes the title used to represent the items being progressed and updates the output' do
    progressbar = ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => output, :length => 80, :throttle_rate => 0.0)
    10.times { progressbar.increment }
    progressbar.title = 'Items'

    output.rewind
    expect(output.read).to match(/\rItems: \|=======#{' ' * 64}\|\r\z/)
  end

  it 'when a bar is started and it is incremented any number of times resets the bar back to the starting value' do
    progressbar = ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => output, :length => 80, :throttle_rate => 0.0)
    10.times { progressbar.increment }
    progressbar.reset
    output.rewind
    expect(output.read).to match(/\rProgress: \|#{' ' * 68}\|\r\z/)
  end

  it 'when a bar is started and it is incremented any number of times forcibly halts the bar wherever it is and cancels it' do
    progressbar = ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => output, :length => 80, :throttle_rate => 0.0)
    10.times { progressbar.increment }
    progressbar.stop
    output.rewind
    expect(output.read).to match(/\rProgress: \|======#{' ' * 62}\|\n\z/)
  end

  it 'when a bar is started and it is incremented any number of times does not output the bar multiple times if the bar is already stopped' do
    progressbar = ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => output, :length => 80, :throttle_rate => 0.0)
    10.times { progressbar.increment }
    progressbar.stop
    output.rewind
    progressbar.stop
    output.rewind

    expect(output.read).to start_with "#{' ' * 80}"
  end

  it 'when a bar is started and it is incremented any number of times does not output the bar multiple times' do
    progressbar = ProgressBar::Base.new(:starting_at => 0, :total => 100, :output => output, :length => 80, :throttle_rate => 0.0)
    10.times { progressbar.increment }
    output.rewind
    progressbar.resume
    output.rewind

    expect(output.read).to start_with "#{' ' * 80}"
  end

  it 'when a bar is started from 10/100 and it is incremented any number of times resets the bar back to the starting value' do
    progressbar = ProgressBar::Base.new(:starting_at => 10, :total => 100, :output => output, :length => 112)
    10.times { progressbar.increment }
    progressbar.reset
    output.rewind
    expect(output.read).to match(/\rProgress: \|==========#{' ' * 90}\|\r\z/)
  end

  it 'clears the current terminal line and/or bar text' do
    progressbar = ProgressBar::Base.new(:output => output, :length => 80, :throttle_rate => 0.0)

    progressbar.clear

    output.rewind
    expect(output.read).to match(/^#{progressbar.send(:output).send(:clear_string)}/)
  end

  it 'starting the bar clears the current terminal line' do
    progressbar = ProgressBar::Base.new(:output => output, :length => 80, :throttle_rate => 0.0)

    progressbar.start

    output.rewind
    expect(output.read).to match(/^#{progressbar.send(:output).send(:clear_string)}/)
  end

  it 'starting the bar prints the bar for the first time' do
    progressbar = ProgressBar::Base.new(:output => output, :length => 80, :throttle_rate => 0.0)

    progressbar.start

    output.rewind
    expect(output.read).to match(/Progress: \|                                                                    \|\r\z/)
  end

  it 'starting the bar prints correctly if passed a position to start at' do
    progressbar = ProgressBar::Base.new(:output => output, :length => 80, :throttle_rate => 0.0)

    progressbar.start(:at => 20)

    output.rewind
    expect(output.read).to match(/Progress: \|=============                                                       \|\r\z/)
  end

  it 'when the bar has not been completed incrementing displays the bar with the correct formatting' do
    progressbar = ProgressBar::Base.new(:length => 112, :starting_at => 0, :total => 50, :output => output, :throttle_rate => 0.0)
    progressbar.increment

    output.rewind
    expect(output.read).to match(/Progress: \|==                                                                                                  \|\r\z/)
  end

  it 'when a new bar is created with a specific format #format if called with no arguments resets the format back to the default' do
    progressbar = ProgressBar::Base.new(:format => '%B %p%%')
    progressbar.format = nil

    expect(progressbar.to_s).to match(/^Progress: \|\s+\|\z/)
  end

  it 'when a new bar is created with a specific format #format if called with a specific format string sets it as the new format for the bar' do
    progressbar = ProgressBar::Base.new(:format => '%B %p%%')
    progressbar.format = '%t'

    expect(progressbar.to_s).to match(/^Progress\z/)
  end

  it 'when the bar is started after having total set to 0 does not throw an error' do
    progressbar = ProgressBar::Base.new(:output => output, :autostart => false)
    progressbar.total = 0

    expect { progressbar.start }.not_to raise_error
  end

  it 'when the bar has no items to process and it has not been started does not throw an error if told to stop' do
    progressbar = ProgressBar::Base.new(:started_at => 0, :total => 0, :autostart => false, :smoothing => 0.0, :format => ' %c/%C |%w>%i| %e ', :output => output)
    progressbar.stop

    expect { progressbar.start }.not_to raise_error
  end
end
end
# rubocop:enable Metrics/LineLength
