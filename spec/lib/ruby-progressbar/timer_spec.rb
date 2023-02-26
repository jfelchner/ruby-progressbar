require 'spec_helper'
require 'ruby-progressbar/timer'

class    ProgressBar
describe Timer do
  it 'can be reset and queried' do
    timer = Timer.new

    timer.start
    timer.reset

    expect(timer.elapsed_seconds).to be 0
  end
end
end
