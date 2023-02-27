require 'spec_helper'
require 'ruby-progressbar/components/rate'

class    ProgressBar
module   Components
describe Rate do
  describe '#rate_of_change' do
    it 'returns the rate as a formatted integer' do
      Timecop.freeze(::Time.utc(2020, 1, 1, 0, 0, 0))

      progress = Progress.new(:total => 100)
      timer    = Timer.new
      rate     = Rate.new(:progress => progress,
                          :timer    => timer)

      progress.start
      timer.start

      progress.progress = 50

      Timecop.freeze(::Time.utc(2020, 1, 1, 0, 0, 10))

      expect(rate.rate_of_change).to eql '5'

      Timecop.return
    end

    it 'can scale the rate' do
      Timecop.freeze(::Time.utc(2020, 1, 1, 0, 0, 0))

      progress = Progress.new(:total => 100)
      timer    = Timer.new
      rate     = Rate.new(:progress   => progress,
                          :timer      => timer,
                          :rate_scale => lambda { |x| x * 2 })

      progress.start
      timer.start

      progress.progress = 50

      Timecop.freeze(::Time.utc(2020, 1, 1, 0, 0, 10))

      expect(rate.rate_of_change).to eql '10'

      Timecop.return
    end
  end

  describe '#rate_of_change_with_precision' do
    it 'returns the rate as a formatted integer' do
      Timecop.freeze(::Time.utc(2020, 1, 1, 0, 0, 0))

      progress = Progress.new(:total => 100)
      timer    = Timer.new
      rate     = Rate.new(:progress => progress,
                          :timer    => timer)

      progress.start
      timer.start

      progress.progress = 50

      Timecop.freeze(::Time.utc(2020, 1, 1, 0, 0, 10))

      expect(rate.rate_of_change_with_precision).to eql '5.00'

      Timecop.return
    end
  end
end
end
end
