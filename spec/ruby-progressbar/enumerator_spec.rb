require 'ruby-progressbar/progress'
require 'ruby-progressbar/enumerator'

RSpec.describe Enumerator do

  let(:n) { 10 }
  let(:a) { 0...n }
  let(:func) { lambda { |i| 10*i } }

  it 'creates a progress bar with the Enumerable size' do
    expect(ProgressBar).to receive(:create).with(hash_including(:total => n)).and_call_original
    a.each.with_progressbar { |_| }
  end

  it 'passes arguments to create' do
    title = "This is a test"
    expect(ProgressBar).to receive(:create).with(hash_including(:title => title)).and_call_original
    a.each.with_progressbar(:title => title) { |_| }
  end

  it 'calls progressbar.increment the right number of times' do
    mock = instance_double(ProgressBar::Progress)
    expect(ProgressBar).to receive(:create).and_return(mock)
    expect(mock).to receive(:increment).exactly(n).times
    a.each.with_progressbar { |_| }
  end

  it 'chains return values properly' do
    expect(a.map.with_progressbar(&func)).to eq a.map(&func)
  end

  it 'chains properly in the middle ' do
    expect(a.each.with_progressbar.map(&func)).to eq a.each.map(&func)
  end

  it 'returns an enumerator' do
    e = a.each.with_progressbar
    expect(e.map(&func)).to eq a.map(&func)
  end
end if defined? Enumerator and Enumerator.method_defined? :size
