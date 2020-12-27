require 'spec_helper'
require 'support/time'
require 'stringio'

class    ProgressBar
describe Base do
  let(:output) do
    StringIO.new('', 'w+').tap do |io|
      allow(io).to receive(:tty?).and_return true
    end
  end

  let(:output_string) do
    output.rewind
    output.read
  end

  let(:non_tty_output) do
    StringIO.new('', 'w+').tap do |io|
      allow(io).to receive(:tty?).and_return false
    end
  end

  let(:non_tty_output_string) do
    non_tty_output.rewind
    non_tty_output.read
  end

  context 'with the title' do
    it 'has a default' do
      progressbar = ProgressBar::Base.new

      expect(progressbar.send(:title)).to \
        eql ProgressBar::Components::Title::DEFAULT_TITLE
    end

    it 'is able to be overridden on creation' do
      progressbar = ProgressBar::Base.new(:title => 'We All Float')

      expect(progressbar.send(:title).to_s).to eql 'We All Float'
    end

    it 'allows title updates even after the bar is started' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :length        => 20,
                                          :throttle_rate => 0.0)

      progressbar.progress = 50
      progressbar.title    = 'Items'

      expect(output_string).to eql "                    \r" \
                                   "Progress: |        |\r" \
                                   "Progress: |====    |\r" \
                                   "Items: |=====      |\r" \
    end

    it 'ignores title changes for a non-TTY enabled devices' do
      progressbar = ProgressBar::Base.new(:output        => non_tty_output,
                                          :length        => 80,
                                          :starting_at   => 10,
                                          :throttle_rate => 0.0)

      progressbar.title = 'Testing'

      expect(non_tty_output_string).to eql "\n" \
                                           "Progress: |======"
    end

    it 'allows for custom title for a non-TTY enabled devices on creation' do
      _progressbar = ProgressBar::Base.new(:output      => non_tty_output,
                                           :title       => 'Custom',
                                           :length      => 80,
                                           :starting_at => 10)

      expect(non_tty_output_string).to eql "\n" \
                                           "Custom: |======="
    end
  end

  context 'with the progress_mark' do
    it 'can be changed even after the bar is started' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :length        => 20,
                                          :throttle_rate => 0.0)

      progressbar.progress      = 30
      progressbar.progress_mark = 'x'

      expect(output_string).to eql "                    \r" \
                                   "Progress: |        |\r" \
                                   "Progress: |==      |\r" \
                                   "Progress: |xx      |\r"
    end
  end

  context 'with the remainder_mark' do
    it 'can be changed even after the bar is started' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :length        => 20,
                                          :throttle_rate => 0.0)

      progressbar.progress       = 30
      progressbar.remainder_mark = 'x'

      expect(output_string).to eql "                    \r" \
                                   "Progress: |        |\r" \
                                   "Progress: |==      |\r" \
                                   "Progress: |==xxxxxx|\r"
    end
  end

  context 'with the output stream' do
    it 'has a default' do
      progressbar    = ProgressBar::Base.new
      default_stream = progressbar.send(:output).send(:stream)

      expect(default_stream).to eql ProgressBar::Output::DEFAULT_OUTPUT_STREAM
    end

    it 'is able to be overridden on creation' do
      progressbar   = ProgressBar::Base.new(:output => $stderr)
      output_stream = progressbar.send(:output).send(:stream)

      expect(output_stream).to eql $stderr
    end
  end

  context 'with the bar length' do
    it 'is able to be overridden on creation' do
      progressbar       = ProgressBar::Base.new(:length => 88)
      length_calculator = progressbar.send(:output).send(:length_calculator)

      expect(length_calculator.send(:length)).to be 88
    end

    it 'can handle the terminal width changing on the fly' do
      progressbar       = ProgressBar::Base.new(:output        => output,
                                                :title         => 'a' * 25,
                                                :format        => '%t|%B|',
                                                :throttle_rate => 0.0)
      length_calculator = progressbar.send(:output).send(:length_calculator)

      allow(length_calculator).to receive(:terminal_width).and_return 30

      progressbar.start

      allow(length_calculator).to receive(:terminal_width).and_return 20

      progressbar.increment

      expect(output_string).to end_with "                              \r" \
                                        "aaaaaaaaaaaaaaaaaaaaaaaaa|   |\r" \
                                        "                    \r" \
                                        "aaaaaaaaaaaaaaaaaaaaaaaaa||\r"
    end
  end

  context 'when starting the bar' do
    it 'clears the current terminal line' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :length        => 20,
                                          :throttle_rate => 0.0)

      progressbar.start

      expect(output_string).to start_with("                    \r")
    end

    it 'prints the bar for the first time' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :length        => 40,
                                          :throttle_rate => 0.0)

      progressbar.start

      expect(output_string).to end_with("Progress: |                            |\r")
    end

    it 'prints correctly when a position to start at is specified' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :length        => 40,
                                          :throttle_rate => 0.0)

      progressbar.start(:at => 20)

      expect(output_string).to end_with("Progress: |=====                       |\r")
    end

    it 'does not blow up if there is a total of zero' do
      progressbar       = ProgressBar::Base.new(:output => output, :autostart => false)
      progressbar.total = 0

      expect { progressbar.start }.not_to raise_error
    end
  end

  context 'when stopping the bar' do
    it 'forcibly halts the bar wherever it is and cancels further progress' do
      progressbar = ProgressBar::Base.new(:output => output, :length => 20)

      progressbar.progress = 33
      progressbar.stop

      expect(output_string).to end_with("\rProgress: |==      |\n")
    end

    it 'forcibly halts the bar wherever it is for a non-TTY enabled devices' do
      progressbar = ProgressBar::Base.new(:output        => non_tty_output,
                                          :length        => 20,
                                          :throttle_rate => 0.0)

      progressbar.progress = 33
      progressbar.stop

      expect(non_tty_output_string).to eql "\n" \
                                           "Progress: |==\n"
    end

    it 'does not output multiple bars if stopped multiple times in a row' do
      progressbar = ProgressBar::Base.new(:output => output, :length => 20)

      progressbar.progress = 10
      progressbar.stop
      progressbar.stop

      expect(output_string).to start_with("                    \r")
    end

    it 'does not error if there is nothing to do and it has not been started' do
      progressbar = ProgressBar::Base.new(:started_at => 0,
                                          :total      => 0,
                                          :autostart  => false,
                                          :format     => ' %c/%C |%w>%i| %e ',
                                          :output     => output)

      expect { progressbar.stop }.not_to raise_error
    end

    it 'appends proper ending to string for non-TTY devices' do
      progressbar = ProgressBar::Base.new(:output => non_tty_output)

      progressbar.stop

      expect(non_tty_output_string).to end_with("\n")
    end
  end

  context 'when finishing the bar' do
    it 'does not spam the screen for a non-TTY enabled devices' do
      progressbar = ProgressBar::Base.new(:output        => non_tty_output,
                                          :length        => 20,
                                          :starting_at   => 0,
                                          :total         => 6,
                                          :throttle_rate => 0.0)

      6.times { progressbar.increment }

      expect(non_tty_output_string).to eql "\n" \
                                           "Progress: |========|\n"
    end

    it 'can finish a bar in the middle of progress for a non-TTY enabled devices' do
      progressbar = ProgressBar::Base.new(:output        => non_tty_output,
                                          :length        => 20,
                                          :starting_at   => 0,
                                          :total         => 6,
                                          :throttle_rate => 0.0)

      progressbar.progress = 3
      progressbar.finish

      expect(non_tty_output_string).to eql "\n" \
                                           "Progress: |========|\n"
    end

    it 'properly prints a newline when incremented to its total' do
      progressbar = ProgressBar::Base.new(:output      => output,
                                          :starting_at => 5,
                                          :total       => 6,
                                          :length      => 20)

      progressbar.increment

      expect(progressbar).to   be_finished
      expect(output_string).to end_with("\n")
    end

    it 'does not spam the screen if the bar is autofinished and finish is called' do
      progressbar = ProgressBar::Base.new(:output      => output,
                                          :starting_at => 5,
                                          :total       => 6,
                                          :length      => 20)

      progressbar.increment
      progressbar.finish

      expect(progressbar).to   be_finished
      expect(output_string).to end_with "                    \r" \
                                        "Progress: |======  |\r" \
                                        "Progress: |========|\n"
    end

    it 'does not autofinish if autofinish is disabled' do
      progressbar = ProgressBar::Base.new(:output      => output,
                                          :starting_at => 5,
                                          :total       => 6,
                                          :length      => 20,
                                          :autofinish  => false)

      progressbar.increment

      expect(progressbar).not_to be_finished
    end

    it 'does not print a newline if incremented to total and autofinish is disabled' do
      progressbar = ProgressBar::Base.new(:output      => output,
                                          :starting_at => 5,
                                          :total       => 6,
                                          :length      => 20,
                                          :autofinish  => false)

      progressbar.increment

      expect(output_string).not_to end_with("\n")
    end

    it 'still allows the bar to be reset if autofinish is disabled' do
      progressbar = ProgressBar::Base.new(:output      => output,
                                          :starting_at => 5,
                                          :total       => 6,
                                          :length      => 20,
                                          :autofinish  => false)

      progressbar.increment
      progressbar.finish

      expect(progressbar).to be_finished

      progressbar.reset

      expect(progressbar).not_to be_finished
    end

    it 'still able to be manually finished even if autofinish is disabled' do
      progressbar = ProgressBar::Base.new(:output      => output,
                                          :starting_at => 5,
                                          :total       => 6,
                                          :length      => 20,
                                          :autofinish  => false)

      progressbar.increment
      progressbar.finish

      expect(progressbar).to   be_finished
      expect(output_string).to end_with("\n")
    end

    it 'does not spam the screen on multiple manual calls when autofinish is disabled' do
      progressbar = ProgressBar::Base.new(:output      => output,
                                          :starting_at => 5,
                                          :total       => 6,
                                          :length      => 20,
                                          :autofinish  => false)

      progressbar.increment
      progressbar.finish

      expect(progressbar).to   be_finished
      expect(output_string).to end_with "                    \r" \
                                        "Progress: |======  |\r" \
                                        "Progress: |========|\n"
    end
  end

  context 'when resetting the bar' do
    it 'sets the bar back to the starting value' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :length        => 20,
                                          :throttle_rate => 0.0)

      progressbar.progress = 33
      progressbar.reset

      expect(output_string).to eql "                    \r" \
                                   "Progress: |        |\r" \
                                   "Progress: |==      |\r" \
                                   "Progress: |        |\r"
    end

    it 'sets the bar back to its starting value set during creation' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :starting_at   => 33,
                                          :total         => 100,
                                          :length        => 20,
                                          :throttle_rate => 0.0)

      progressbar.progress += 10
      progressbar.reset

      expect(output_string).to eql "                    \r" \
                                   "Progress: |==      |\r" \
                                   "Progress: |===     |\r" \
                                   "Progress: |==      |\r"
    end

    it 'displays the unknown estimated time' do
      progressbar = ProgressBar::Base.new(:output => output,
                                          :total  => 100,
                                          :format => '%e')

      progressbar.progress += 10
      progressbar.reset
      progressbar.progress += 10

      expect(progressbar.to_s).to eql ' ETA: ??:??:??'
    end
  end

  context 'when logging messages' do
    it 'can log messages for a TTY enabled device' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :length        => 20,
                                          :starting_at   => 3,
                                          :total         => 6,
                                          :throttle_rate => 0.0)

      progressbar.increment
      progressbar.log 'We All Float'
      progressbar.increment

      expect(output_string).to eql "                    \r" \
                                   "Progress: |====    |\r" \
                                   "Progress: |=====   |\r" \
                                   "                    \r" \
                                   "We All Float\n" \
                                   "Progress: |=====   |\r" \
                                   "Progress: |======  |\r"
    end

    it 'can log messages for a non-TTY enabled device' do
      progressbar = ProgressBar::Base.new(:output        => non_tty_output,
                                          :length        => 20,
                                          :starting_at   => 4,
                                          :total         => 6,
                                          :throttle_rate => 0.0)

      progressbar.increment
      progressbar.log 'We All Float'
      progressbar.increment
      progressbar.finish

      expect(non_tty_output_string).to eql "\n" \
                                           "Progress: |======\n" \
                                           "We All Float\n" \
                                           "Progress: |========|\n"
    end
  end

  context 'when formatting the bar' do
    it 'allows the bar format to be updated dynamically after it is started' do
      progressbar = ProgressBar::Base.new(:output => output,
                                          :format => '%B %p%%',
                                          :length => 20)

      expect(progressbar.to_s).to eql "#{' ' * 18}0%"

      progressbar.format = '%t'

      expect(progressbar.to_s).to eql 'Progress'
    end

    it 'allows the bar to be reset back to the default format' do
      progressbar = ProgressBar::Base.new(:output => output,
                                          :format => '%B %p%%',
                                          :length => 100)

      expect(progressbar.to_s).to eql "#{' ' * 98}0%"

      progressbar.format = nil

      expect(progressbar.to_s).to eql "Progress: |#{' ' * 88}|"
    end

    it 'allows for the format to be loaded from an environment variable' do
      ENV['RUBY_PROGRESS_BAR_FORMAT'] = ' %c/%C |%w>%i| %e '

      progressbar = ProgressBar::Base.new(:output => output,
                                          :length => 10)

      expect(progressbar.to_s).to eql ' 0/100 |>|  ETA: ??:??:?? '

      ENV['RUBY_PROGRESS_BAR_FORMAT'] = nil
    end
  end

  context 'when clearing the bar' do
    it 'clears the current terminal line and/or bar text' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :starting_at   => 40,
                                          :length        => 20,
                                          :throttle_rate => 0.0)

      progressbar.clear

      expect(output_string).to eql "                    \r" \
                                   "Progress: |===     |\r" \
                                   "                    \r"
    end
  end

  context 'when incrementing the bar' do
    it 'displays the bar with the correct progress' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :length        => 20,
                                          :starting_at   => 0,
                                          :total         => 6,
                                          :throttle_rate => 0.0)

      progressbar.increment

      expect(output_string).to eql "                    \r" \
                                   "Progress: |        |\r" \
                                   "Progress: |=       |\r"
    end
  end

  context 'when decrementing the bar' do
    it 'displays the bar with the correct progress' do
      progressbar = ProgressBar::Base.new(:output        => output,
                                          :length        => 20,
                                          :starting_at   => 1,
                                          :total         => 6,
                                          :throttle_rate => 0.0)

      progressbar.decrement

      expect(output_string).to eql "                    \r" \
                                   "Progress: |=       |\r" \
                                   "Progress: |        |\r"
    end

    context 'with non-TTY enabled devices' do
      it 'does nothing' do
        progressbar = ProgressBar::Base.new(:output        => non_tty_output,
                                            :length        => 20,
                                            :starting_at   => 2,
                                            :total         => 6,
                                            :throttle_rate => 0.0)
        progressbar.decrement

        expect(non_tty_output_string).to eql "\n" \
                                             "Progress: |=="
      end
    end
  end

  it 'can be converted into a hash', :time_mock => ::Time.utc(2012, 7, 26, 18, 0, 0) do
    progressbar = ProgressBar::Base.new(:output         => output,
                                        :total          => 33,
                                        :title          => 'My Title',
                                        :format         => '%t|%B|',
                                        :progress_mark  => 'x',
                                        :remainder_mark => '-',
                                        :length         => 92,
                                        :rate_scale     => lambda { |rate| rate * 200 },
                                        :throttle_rate  => 12.3)

    Timecop.travel(-600) do
      progressbar.start
      progressbar.progress += 22
    end

    expect(progressbar.to_h).to \
      include(
        'output_stream'                       => be_a(StringIO),
        'length'                              => 92,
        'elapsed_time_in_seconds'             => be_within(0.01).of(600),
        'estimated_time_remaining_in_seconds' => 400,
        'percentage'                          => 66.66,
        'progress'                            => 22,
        'progress_mark'                       => 'x',
        'base_rate_of_change'                 => 0.03672787979966611,
        'scaled_rate_of_change'               => 7.345575959933222,
        'remainder_mark'                      => '-',
        'throttle_rate'                       => 12.3,
        'title'                               => 'My Title',
        'total'                               => 33,
        'unknown_progress_animation_steps'    => [
                                                   '=---',
                                                   '-=--',
                                                   '--=-',
                                                   '---='
                                                 ],
        'started?'                            => be_within(1).of(::Time.now.utc - 600),
        'stopped?'                            => false,
        'finished?'                           => false
    )
  end
end
end
