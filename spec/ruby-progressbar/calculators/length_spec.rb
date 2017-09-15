require 'spec_helper'
require 'ruby-progressbar/calculators/length'

class     ProgressBar
module    Calculators
describe  Length do
  context 'when the RUBY_PROGRESS_BAR_LENGTH environment variable exists' do
    before  { ENV['RUBY_PROGRESS_BAR_LENGTH'] = '44' }
    after   { ENV['RUBY_PROGRESS_BAR_LENGTH'] = nil }

    it 'calculates the length as the value of the environment variable as an integer' do
      length_calculator = Calculators::Length.new

      expect(length_calculator.length).to eql 44
    end
  end

  if RUBY_PLATFORM != 'java' &&
     Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('1.9.3')

    it 'can properly calculate the length even if IO.console is nil' do
      calculator = Length.new

      expect(IO).to         receive(:console).and_return nil
      expect(calculator).to receive(:dynamic_width_via_system_calls).and_return 123_456

      expect(calculator.calculate_length).to eql 123_456
    end
  end

  it 'allows the length to be overridden on creation' do
    length_calculator = Calculators::Length.new(:length => 88)

    expect(length_calculator.length).to eql 88
  end

  it 'can calculate the width of the terminal in Unix environments' do
    length_calculator = Calculators::Length.new

    allow(length_calculator).to receive(:unix?).and_return(true)
    allow(length_calculator).to receive(:dynamic_width).and_return(99)

    expect(length_calculator.length).to eql 99
  end

  it 'if output is a tty, uses it to calculate length in unix environments' do
    stream = instance_double('IO')
    expect(stream).to receive(:tty?).and_return true
    expect(stream).to receive(:winsize).and_return [123, 456]
    expect(IO).not_to receive(:console)

    length_calculator = Calculators::Length.new(output: stream)
    allow(length_calculator).to receive(:unix?).and_return(true)
    expect(length_calculator.length).to eql 456
  end

  it 'if output is null, falls back on IO.console to calculate length in unix environments' do
    console = instance_double('IO')
    expect(IO).to receive(:console).and_return(console).at_least(:once)
    expect(console).to receive(:winsize).and_return [123, 456]

    length_calculator = Calculators::Length.new
    allow(length_calculator).to receive(:unix?).and_return(true)
    expect(length_calculator.length).to eql 456
  end

  it 'if output is not a tty, falls back on IO.console to calculate length in unix environments' do
    stream = instance_double('IO')
    expect(stream).to receive(:tty?).and_return false
    expect(stream).not_to receive(:winsize)

    console = instance_double('IO')
    expect(IO).to receive(:console).and_return(console).at_least(:once)
    expect(console).to receive(:winsize).and_return [123, 456]

    length_calculator = Calculators::Length.new(output: stream)
    allow(length_calculator).to receive(:unix?).and_return(true)
    expect(length_calculator.length).to eql 456
  end

  it 'defaults to 80 if it is not a Unix environment' do
    length_calculator = Calculators::Length.new

    allow(length_calculator).to receive(:unix?).and_return(false)

    expect(length_calculator.length).to eql 80
  end

  it 'defaults to 80 if the width is less than 20' do
    length_calculator = Calculators::Length.new

    allow(length_calculator).to receive(:unix?).and_return(true)
    allow(length_calculator).to receive(:dynamic_width).and_return(19)

    expect(length_calculator.length).to eql 80
  end
end
end
end
