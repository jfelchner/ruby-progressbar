require 'spec_helper'
require 'ruby-progressbar/progress'

class    ProgressBar
describe Progress do
  it 'knows the default total when no parameters are passed' do
    progress = Progress.new

    expect(progress.total).to eql Progress::DEFAULT_TOTAL
  end

  it 'knows the default beginning progress when no parameters are passed and ' \
     'the progress has not been started' do

    progress = Progress.new

    expect(progress.progress).to be_zero
  end

  it 'knows the default starting value when no parameters are passed and the ' \
     'progress has been started' do

    progress = Progress.new

    progress.start

    expect(progress.progress).to eql Progress::DEFAULT_BEGINNING_POSITION
  end

  it 'knows the given starting value when no parameters are passed and the ' \
     'progress is started with a starting value' do

    progress = Progress.new

    progress.start :at => 10

    expect(progress.progress).to be 10
  end

  it 'knows how to finish itself even if the total is unknown' do
    progress = Progress.new :total => nil

    expect(progress.finish).to be(nil)
  end

  it 'knows the overridden total when the total is passed in' do
    progress = Progress.new(:total          => 12,
                            :progress_mark  => 'x',
                            :remainder_mark => '.')

    expect(progress.total).to be 12
  end

  it 'knows the percentage completed when begun with no progress' do
    progress = Progress.new

    progress.start

    expect(progress.percentage_completed).to be 0
  end

  it 'knows the progress after it has been incremented' do
    progress = Progress.new

    progress.start
    progress.increment

    expect(progress.progress).to be 1
  end

  it 'knows the percentage completed after it has been incremented' do
    progress = Progress.new(:total => 50)

    progress.start
    progress.increment

    expect(progress.percentage_completed).to be 2
  end

  it 'knows to always round down the percentage completed' do
    progress = Progress.new(:total => 200)

    progress.start :at => 1

    expect(progress.percentage_completed).to be 0
  end

  it 'cannot increment past the total' do
    progress = Progress.new(:total => 50)

    progress.start :at => 50
    progress.increment

    expect(progress.progress).to be 50
    expect(progress.percentage_completed).to be 100
  end

  it 'allow progress to be decremented once it is finished' do
    progress = Progress.new(:total => 50)

    progress.start :at => 50
    progress.decrement

    expect(progress.progress).to be 49
    expect(progress.percentage_completed).to be 98
  end

  it 'knows the percentage completed is 100% if the total is zero' do
    progress = Progress.new(:total => 0)

    expect(progress.percentage_completed).to be 100
  end

  it 'raises an error when passed a number larger than the total' do
    progress = Progress.new(:total => 100)

    expect { progress.progress = 101 }.
      to \
        raise_error(InvalidProgressError,
                    "You can't set the item's current value to be greater " \
                    "than the total.")
  end
end
end
