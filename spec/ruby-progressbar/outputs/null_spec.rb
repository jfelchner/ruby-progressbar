require 'spec_helper'
require 'ruby-progressbar/outputs/null'

class    ProgressBar
module   Outputs
describe Null do
  let(:output_io) { StringIO.new }

  it 'does not output anything ever' do
    allow_any_instance_of(Null).to receive(:stream).and_return(output_io) # rubocop:disable RSpec/AnyInstance

    progressbar = ProgressBar::Base.new(:length => 20, :output => Null)

    progressbar.increment
    progressbar.log('hello')
    progressbar.progress += 20
    progressbar.reset
    progressbar.finish

    output_io.rewind

    expect(output_io.read).to be_empty
  end
end
end
end
