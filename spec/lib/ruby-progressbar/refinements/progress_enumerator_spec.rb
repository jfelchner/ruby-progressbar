if Module.private_instance_methods.include?(:using)

require 'spec_helper'
require 'ruby-progressbar/refinements/progress_enumerator'

class    ProgressBar
module   Refinements
describe Enumerator do
  using ProgressBar::Refinements::Enumerator

  it 'creates a progress bar with the Enumerable size' do
    allow(ProgressBar).to receive(:create).
                          and_call_original

    (0...10).each.with_progressbar { |_x| nil }

    expect(ProgressBar).to have_received(:create).
                           with(hash_including(:total => 10))
  end

  it 'does not allow the user to override the progress bar total' do
    allow(ProgressBar).to receive(:create).
                          and_call_original

    (0...10).each.with_progressbar(:total => 20) { |_x| nil }

    expect(ProgressBar).to have_received(:create).
                           with(hash_including(:total => 10))
  end

  it 'does not allow the user to override the progress bar starting position' do
    allow(ProgressBar).to receive(:create).
                          and_call_original

    (0...10).each.with_progressbar(:starting_at => 20) { |_x| nil }

    expect(ProgressBar).to have_received(:create).
                           with(hash_including(:starting_at => 0))
  end

  it 'passes arguments to create' do
    allow(ProgressBar).to receive(:create).
                          and_call_original

    (0...10).each.with_progressbar(:title => 'We All Float') { |_x| nil }

    expect(ProgressBar).to have_received(:create).
                           with(hash_including(:title => 'We All Float'))
  end

  it 'calls progressbar.increment the right number of times' do
    mock = instance_double('ProgressBar::Progress')

    allow(ProgressBar).to receive(:create).and_return(mock)
    allow(mock).to        receive(:increment)

    (0...10).each.with_progressbar { |_x| nil }

    expect(ProgressBar).to have_received(:create)
    expect(mock).to        have_received(:increment).exactly(10).times
  end

  it 'chains return values properly' do
    transform = lambda { |i| 10 * i }

    chained_progress_transform = (0...10).map.with_progressbar(&transform)
    direct_transform           = (0...10).map(&transform)

    expect(chained_progress_transform).to eql direct_transform
  end

  it 'chains properly in the middle' do
    transform = lambda { |i| 10 * i }

    chained_progress_transform = (0...10).each.with_progressbar.map(&transform)
    direct_transform           = (0...10).each.map(&transform)

    expect(chained_progress_transform).to eql direct_transform
  end

  it 'returns an enumerator' do
    transform  = lambda { |i| 10 * i }
    enumerator = (0...10).each.with_progressbar

    expect(enumerator.map(&transform)).to eql((0...10).map(&transform))
  end

  it 'passes the progressbar instance to the block when two arguments are requested for the block' do
    progress     = 0
    current_item = -1

    (0...10).each.with_progressbar do |item, progress_bar|
      expect(progress_bar.progress).to be(progress += 1)
      expect(item).to be(current_item += 1)
    end
  end
end
end
end
end
