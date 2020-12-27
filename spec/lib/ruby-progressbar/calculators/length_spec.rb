require 'spec_helper'
require 'ruby-progressbar/calculators/length'

class     ProgressBar
module    Calculators
describe  Length do
  let(:tty_output) do
    IO.new(IO.sysopen('/dev/null', 'w')).tap do |io|
      allow(io).to receive(:tty?).and_return true
    end
  end

  let(:non_tty_output) do
    IO.new(IO.sysopen('/dev/null', 'w')).tap do |io|
      allow(io).to receive(:tty?).and_return false
    end
  end

  context 'when the RUBY_PROGRESS_BAR_LENGTH environment variable exists' do
    before(:each)  { ENV['RUBY_PROGRESS_BAR_LENGTH'] = '44' }

    after(:each)   { ENV['RUBY_PROGRESS_BAR_LENGTH'] = nil }

    it 'calculates the length as the value of the environment variable as an integer' do
      length_calculator = Calculators::Length.new

      expect(length_calculator.length).to be 44
    end
  end

  if RUBY_PLATFORM != 'java' &&
     Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('1.9.3')

    it 'can properly calculate the length even if IO.console is nil' do
      calculator = Length.new

      allow(IO).to         receive(:console).and_return nil
      allow(calculator).to receive(:dynamic_width_via_system_calls).and_return 123_456

      expect(calculator.calculate_length).to be 123_456
    end
  end

  it 'allows the length to be overridden on creation' do
    length_calculator = Calculators::Length.new(:length => 88)

    expect(length_calculator.length).to be 88
  end

  it 'can calculate the width of the terminal in Unix environments' do
    length_calculator = Calculators::Length.new

    allow(length_calculator).to receive(:unix?).and_return(true)
    allow(length_calculator).to receive(:dynamic_width).and_return(99)

    expect(length_calculator.length).to be 99
  end

  unless RUBY_VERSION.start_with?('1.')
    it 'asks stream for length if it is a TTY' do
      allow(tty_output).to receive(:winsize).and_return [123, 456]
      allow(IO).to         receive(:console).and_call_original

      length_calculator = Calculators::Length.new(:output => tty_output)

      expect(IO).not_to                   have_received :console
      expect(length_calculator.length).to be 456
    end

    it 'asks IO.console to calculate length if the output is null' do
      allow(tty_output).to receive(:winsize).and_return [123, 456]
      allow(IO).to         receive(:console).and_return(tty_output)

      length_calculator = Calculators::Length.new

      expect(length_calculator.length).to be 456
      expect(IO).to                       have_received(:console).
                                          at_least(:once)
    end

    it 'asks IO.console to calculate length if the output is not a TTY' do
      allow(non_tty_output).to receive(:winsize).and_return [654, 321]
      allow(tty_output).to     receive(:winsize).and_return [123, 456]
      allow(IO).to             receive(:console).and_return(tty_output)

      length_calculator = Calculators::Length.new(:output => non_tty_output)

      expect(length_calculator.length).to be 456
    end
  end

  it 'defaults to 80 if it is not a Unix environment' do
    length_calculator = Calculators::Length.new

    allow(length_calculator).to receive(:unix?).and_return(false)

    expect(length_calculator.length).to be 80
  end

  it 'defaults to 80 if the width is less than 20' do
    length_calculator = Calculators::Length.new

    allow(length_calculator).to receive(:unix?).and_return(true)
    allow(length_calculator).to receive(:dynamic_width).and_return(19)

    expect(length_calculator.length).to be 80
  end
end
end
end
