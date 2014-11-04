require 'rspectacular'
require 'ruby-progressbar/progress'

class     ProgressBar
describe  Progress do
  it 'raises an error when passed a number larger than the total' do
    progress = Progress.new(:total => 100)

    expect { progress.progress = 101 }.to raise_error(InvalidProgressError, "You can't set the item's current value to be greater than the total.")
  end
end
end
