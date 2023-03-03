require 'spec_helper'
require 'ruby-progressbar/progress'

class    ProgressBar
describe Progress do
  it 'knows the default total when no parameters are passed' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:projector => projector)

    expect(progress.total).to eql Progress::DEFAULT_TOTAL
  end

  it 'knows the default beginning progress when no parameters are passed and ' \
     'the progress has not been started' do

    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:projector => projector)

    expect(progress.progress).to be_zero
  end

  it 'knows the default starting value when no parameters are passed and the ' \
     'progress has been started' do

    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:projector => projector)

    progress.start

    expect(progress.progress).to eql Progress::DEFAULT_BEGINNING_POSITION
  end

  it 'knows the given starting value when no parameters are passed and the ' \
     'progress is started with a starting value' do

    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:projector => projector)

    progress.start :at => 10

    expect(progress.progress).to be 10
  end

  it 'knows how to finish itself even if the total is unknown' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:total => nil, :projector => projector)

    expect(progress.finish).to be(nil)
  end

  it 'knows the overridden total when the total is passed in' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:projector      => projector,
                              :total          => 12,
                              :progress_mark  => 'x',
                              :remainder_mark => '.')

    expect(progress.total).to be 12
  end

  it 'knows the percentage completed when begun with no progress' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:projector => projector)

    progress.start

    expect(progress.percentage_completed).to be 0
  end

  it 'knows the progress after it has been incremented' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:projector => projector)

    progress.start
    progress.increment

    expect(progress.progress).to be 1
  end

  it 'knows the percentage completed after it has been incremented' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:total => 50, :projector => projector)

    progress.start
    progress.increment

    expect(progress.percentage_completed).to be 2
  end

  it 'knows to always round down the percentage completed' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:total => 200, :projector => projector)

    progress.start :at => 1

    expect(progress.percentage_completed).to be 0
  end

  it 'cannot increment past the total' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:total => 50, :projector => projector)

    progress.start :at => 50
    progress.increment

    expect(progress.progress).to be 50
    expect(progress.percentage_completed).to be 100
  end

  it 'allow progress to be decremented once it is finished' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:total => 50, :projector => projector)

    progress.start :at => 50
    progress.decrement

    expect(progress.progress).to be 49
    expect(progress.percentage_completed).to be 98
  end

  # rubocop:disable RSpec/BeEql
  it 'knows the running average even when progress has been made' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:total => 50, :projector => projector)

    projector.__send__(:projection=, 10)
    projector.start
    progress.start :at => 0

    expect(progress.running_average).to be_zero

    progress.progress += 40

    expect(progress.running_average).to eql 36.0
  end

  it 'knows the running average is reset even after progress is started' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:total => 50, :projector => projector)

    projector.__send__(:projection=, 10)
    projector.start
    progress.start :at => 0

    expect(progress.running_average).to be_zero

    progress.start :at => 40

    expect(progress.running_average).to eql 0.0
  end
  # rubocop:enable RSpec/BeEql

  it 'knows the percentage completed is 100% if the total is zero' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:total => 0, :projector => projector)

    expect(progress.percentage_completed).to be 100
  end

  it 'raises an error when passed a number larger than the total' do
    projector  = Calculators::SmoothedAverage.new
    progress   = Progress.new(:total => 100, :projector => projector)

    expect { progress.progress = 101 }.
      to \
        raise_error(InvalidProgressError,
                    "You can't set the item's current value to be greater " \
                    "than the total.")
  end
end
end
