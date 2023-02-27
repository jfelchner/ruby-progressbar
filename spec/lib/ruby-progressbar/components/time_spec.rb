require 'spec_helper'
require 'ruby-progressbar/components/time'

class    ProgressBar
module   Components
describe Time do
  describe '#elapsed_with_label' do
    it 'displays unknown elapsed time when the timer has not been started' do
      timer    = Timer.new
      progress = Progress.new
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      expect(time.elapsed_with_label).to eql 'Time: --:--:--'
    end

    it 'displays elapsed time when the timer has just been started' do
      timer    = Timer.new
      progress = Progress.new
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      timer.start

      expect(time.elapsed_with_label).to eql 'Time: 00:00:00'
    end

    it 'displays elapsed time if it was previously started' do
      timer    = Timer.new
      progress = Progress.new
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-16_093)

      timer.start

      Timecop.return

      expect(time.elapsed_with_label).to eql 'Time: 04:28:13'
    end

    it 'displays elapsed time frozen to a specific time if it was previously stopped' do
      timer    = Timer.new
      progress = Progress.new
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-16_093)

      timer.start

      Timecop.return
      Timecop.freeze(-32)

      timer.stop

      Timecop.return

      expect(time.elapsed_with_label).to eql 'Time: 04:27:41'
    end

    it 'displays unknown elapsed time after reset has been called' do
      timer    = Timer.new
      progress = Progress.new
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-16_093)

      timer.start

      Timecop.return

      timer.reset

      expect(time.elapsed_with_label).to eql 'Time: --:--:--'
    end
  end

  describe '#estimated_with_unknown_oob' do
    it 'displays estimated time if it is known' do
      timer    = Timer.new
      progress = Progress.new(:total                => 100,
                              :running_average_rate => 0.0)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-13_332)

      timer.start
      50.times { progress.increment }

      Timecop.return

      expect(time.estimated_with_unknown_oob).to eql ' ETA: 03:42:12'
    end

    it 'displays an unknown estimated time remaining when the timer has been started ' \
       'but no progress has been made' do
      timer    = Timer.new
      progress = Progress.new(:total => 100)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      timer.start

      expect(time.estimated_with_unknown_oob).to eql ' ETA: ??:??:??'
    end

    it 'displays unknown time remaining when progress has been made and then progress ' \
       'is reset' do
      timer    = Timer.new
      progress = Progress.new(:total => 100)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-13_332)

      timer.start
      50.times { progress.increment }

      Timecop.return

      progress.reset

      expect(time.estimated_with_unknown_oob).to eql ' ETA: ??:??:??'
    end

    it 'displays estimated time of "??:??:??" when estimated time is out of bounds ' \
       'and the out of bounds format is set to "unknown"' do
      timer    = Timer.new
      progress = Progress.new(:total => 100, :running_average_rate => 0.0)
      time     = Time.new(:out_of_bounds_time_format => :unknown,
                          :timer                     => timer,
                          :progress                  => progress)

      Timecop.freeze(-120_000)

      timer.start
      25.times { progress.increment }

      Timecop.return

      expect(time.estimated_with_unknown_oob).to eql ' ETA: ??:??:??'
    end

    it 'displays smoothed unknown estimated time when reset is called after progress ' \
       'is made' do
      timer    = Timer.new
      progress = Progress.new(:total => 100, :running_average_rate => 0.5)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-13_332)

      timer.start
      50.times { progress.increment }

      Timecop.return

      progress.reset

      expect(time.estimated_with_unknown_oob).to eql ' ETA: ??:??:??'
    end
  end

  describe '#estimated_with_friendly_oob' do
    it 'displays estimated time if it is known' do
      timer    = Timer.new
      progress = Progress.new(:total                => 100,
                              :running_average_rate => 0.0)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-13_332)

      timer.start
      50.times { progress.increment }

      Timecop.return

      expect(time.estimated_with_friendly_oob).to eql ' ETA: 03:42:12'
    end

    it 'displays estimated time of "> 4 Days" when estimated time is out of bounds ' \
       'and the out of bounds format is set to "friendly"' do
      timer    = Timer.new
      progress = Progress.new(:total => 100, :running_average_rate => 0.0)
      time     = Time.new(:out_of_bounds_time_format => :friendly,
                          :timer                     => timer,
                          :progress                  => progress)

      Timecop.freeze(-120_000)

      timer.start
      25.times { progress.increment }

      Timecop.return

      expect(time.estimated_with_friendly_oob).to eql ' ETA: > 4 Days'
    end
  end

  describe '#estimated_with_no_oob' do
    it 'displays estimated time if it is known' do
      timer    = Timer.new
      progress = Progress.new(:total                => 100,
                              :running_average_rate => 0.0)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-13_332)

      timer.start
      50.times { progress.increment }

      Timecop.return

      expect(time.estimated_with_no_oob).to eql ' ETA: 03:42:12'
    end

    it 'displays actual estimated time when estimated time is out of bounds and the ' \
       'out of bounds format is unset' do
      timer    = Timer.new
      progress = Progress.new(:total => 100, :running_average_rate => 0.0)
      time     = Time.new(:out_of_bounds_time_format => nil,
                          :timer                     => timer,
                          :progress                  => progress)

      Timecop.freeze(-120_000)

      timer.start
      25.times { progress.increment }

      Timecop.return

      expect(time.estimated_with_no_oob).to eql ' ETA: 100:00:00'
    end
  end

  describe '#estimated_with_label' do
    it 'does not display unknown time remaining when the timer has been started and ' \
       'it is incremented' do
      timer    = Timer.new
      progress = Progress.new(:total => 100)
      time = Time.new(:timer    => timer,
                      :progress => progress)

      timer.start
      progress.increment

      expect(time.estimated_with_label).to eql ' ETA: 00:00:00'
    end

    it 'displays unsmoothed time remaining when progress has been made' do
      timer    = Timer.new
      progress = Progress.new(:total => 100, :running_average_rate => 0.0)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-13_332)

      timer.start
      50.times { progress.increment }

      Timecop.return

      expect(time.estimated_with_label).to eql ' ETA: 03:42:12'
    end

    it 'displays unsmoothed time remaining when progress has been made even after the ' \
       'bar is decremented' do
      timer    = Timer.new
      progress = Progress.new(:total => 100, :running_average_rate => 0.0)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-13_332)

      timer.start
      50.times { progress.increment }

      Timecop.return

      20.times { progress.decrement }

      expect(time.estimated_with_label).to eql ' ETA: 08:38:28'
    end

    it 'displays smoothed estimated time properly even when taking decrements into ' \
       'account' do
      timer    = Timer.new
      progress = Progress.new(:total => 100, :running_average_rate => 0.5)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-13_332)

      timer.start
      50.times { progress.increment }

      Timecop.return

      20.times { progress.decrement }

      expect(time.estimated_with_label).to eql ' ETA: 08:14:34'
    end

    it 'displays smoothed estimated time after progress has been made' do
      timer    = Timer.new
      progress = Progress.new(:total => 100, :running_average_rate => 0.5)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-13_332)

      timer.start
      50.times { progress.increment }

      Timecop.return

      expect(time.estimated_with_label).to eql ' ETA: 03:51:16'
    end

    it 'displays the estimated time remaining properly even for progress increments ' \
       'very short intervals' do
      timer    = Timer.new
      progress = Progress.new(:total => 10, :running_average_rate => 0.1)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      estimated_time_results = []
      now                    = ::Time.now

      Timecop.freeze(now)

      timer.start

      10.times do
        Timecop.freeze(now += 0.5)
        progress.increment

        estimated_time_results << time.estimated_with_label
      end

      Timecop.return

      expect(estimated_time_results).to \
        eql(
          [
            ' ETA: 00:00:05',
            ' ETA: 00:00:04',
            ' ETA: 00:00:04',
            ' ETA: 00:00:03',
            ' ETA: 00:00:03',
            ' ETA: 00:00:02',
            ' ETA: 00:00:02',
            ' ETA: 00:00:01',
            ' ETA: 00:00:01',
            ' ETA: 00:00:00'
          ]
        )
    end
  end

  describe '#estimated_wall_clock' do
    it 'displays the wall clock time as unknown when the timer has been reset' do
      timer    = Timer.new
      progress = Progress.new
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-16_093)

      timer.start

      Timecop.return

      timer.reset

      expect(time.estimated_wall_clock).to eql '--:--:--'
    end

    it 'displays the wall clock time as unknown when the progress has not begun' do
      timer    = Timer.new
      progress = Progress.new
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(-16_093)

      timer.start

      Timecop.return

      expect(time.estimated_wall_clock).to eql '--:--:--'
    end

    it 'displays the completed wall clock time if the progress is finished' do
      timer    = Timer.new
      progress = Progress.new
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(::Time.utc(2020, 1, 1, 0, 0, 0))

      timer.start

      Timecop.freeze(::Time.utc(2020, 1, 1, 0, 30, 0))

      timer.stop
      progress.finish

      Timecop.return

      expect(time.estimated_wall_clock).to eql '00:30:00'
    end

    it 'displays the estimated wall clock time if the progress is ongoing' do
      timer    = Timer.new
      progress = Progress.new(:running_average_rate => 0.0)
      time     = Time.new(:timer    => timer,
                          :progress => progress)

      Timecop.freeze(::Time.utc(2020, 1, 1, 0, 0, 0))

      timer.start
      progress.progress = 50

      Timecop.freeze(::Time.utc(2020, 1, 1, 0, 15, 0))

      wall_clock = time.estimated_wall_clock

      Timecop.return

      expect(wall_clock).to eql '00:30:00'
    end
  end
end
end
end
