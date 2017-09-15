require 'spec_helper'
require 'ruby-progressbar/output'

class MyTestOutput < ProgressBar::Output
  def clear; end

  def bar_update_string
    bar.to_s
  end

  def log(_string)
    stream.puts 'We All Float'
  end

  def resolve_format(*)
    '%t |%B|'
  end

  def eol
    bar.stopped? ? "\n" : "\r"
  end
end

class    ProgressBar
describe Output do
  let(:output_io) { StringIO.new }

  it 'uses the passed in output class if it is a ProgressBar::Output' do
    allow_any_instance_of(MyTestOutput).to receive(:stream).and_return(output_io)

    progressbar = ProgressBar::Base.new(:length => 20, :output => MyTestOutput)

    progressbar.log('hello')

    output_io.rewind

    expect(output_io.read).to eql "Progress |         |\r" \
                                  "We All Float\n"
  end
end
end
