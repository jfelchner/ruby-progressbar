require 'spec_helper'
require 'ruby-progressbar/projector'

class    ProgressBar
describe Projector do
  describe '.from_type' do
    it 'has a default projector' do
      projector = Projector.from_type(nil)

      expect(projector).to be ProgressBar::Projectors::SmoothedAverage
    end

    it 'can return a specific projector' do
      projector = Projector.from_type('smoothed')

      expect(projector).to be ProgressBar::Projectors::SmoothedAverage
    end
  end
end
end
