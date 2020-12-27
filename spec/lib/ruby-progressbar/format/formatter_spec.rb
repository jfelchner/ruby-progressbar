require 'spec_helper'
require 'support/time'
require 'ruby-progressbar/format/formatter'

class    ProgressBar
module   Format
describe Formatter do
  let(:to_the_past)           { -3_723 }
  let(:one_hundred_hours_ago) { -360_000 }
  let(:four_minutes_ago)      { -240 }
  let(:one_minute_ago)        { -60 }

  context 'with the %% flag' do
    let(:format) { Format::String.new('%%') }

    it 'displays a literal percent sign' do
      progressbar = ProgressBar::Base.new(:starting_at => 66, :total => 99)

      expect(Formatter.process(format, 100, progressbar)).to eql '%'
    end
  end

  context 'with the %a flag' do
    let(:format) { Format::String.new('%a') }

    it 'is "--:--:--" when displayed after starting the bar and then resetting the bar' do
      progressbar = ProgressBar::Base.new

      Timecop.freeze(to_the_past) do
        progressbar.start
      end

      progressbar.reset

      expect(Formatter.process(format, 100, progressbar)).to eql 'Time: --:--:--'
    end

    it 'is the time elapsed when displayed after starting the bar' do
      progressbar = ProgressBar::Base.new(:throttle_rate => 0.0)

      Timecop.freeze(to_the_past) do
        progressbar.start
      end

      expect(Formatter.process(format, 100, progressbar)).to eql 'Time: 01:02:03'
    end

    it 'is the total amount of time elapsed once the bar finishes' do
      progressbar = ProgressBar::Base.new(:throttle_rate => 0.0)

      Timecop.freeze(four_minutes_ago) do
        progressbar.start
      end

      Timecop.freeze(one_minute_ago) do
        progressbar.finish
      end

      expect(Formatter.process(format, 100, progressbar)).to eql 'Time: 00:03:00'
    end
  end

  context 'with the %b flag' do
    let(:format) { Format::String.new('%b') }

    it 'is the bar (excluding incomplete space)' do
      progressbar = ProgressBar::Base.new(:starting_at => 20)
      expect(Formatter.process(format, 100, progressbar)).to eql('=' * 20)
    end
  end

  context 'with the %B flag' do
    let(:format) { Format::String.new('%B') }

    it 'is the bar (including incomplete space)' do
      progressbar = ProgressBar::Base.new(:starting_at => 20)

      expect(Formatter.process(format, 100, progressbar)).to eql "#{'=' * 20}#{' ' * 80}"
    end
  end

  context 'with the %c flag' do
    let(:format) { Format::String.new('%c') }

    it 'is the current capacity/progress' do
      progressbar = ProgressBar::Base.new

      expect(Formatter.process(format, 100, progressbar)).to eql '0'
      progressbar.increment
      expect(Formatter.process(format, 100, progressbar)).to eql '1'
      progressbar.decrement
      expect(Formatter.process(format, 100, progressbar)).to eql '0'
    end
  end

  context 'with the %C flag' do
    let(:format) { Format::String.new('%C') }

    it 'is the total capacity/progress' do
      progressbar = ProgressBar::Base.new(:total => 100)

      expect(Formatter.process(format, 100, progressbar)).to eql '100'
    end

    it 'is nothing when the total is unknown' do
      progressbar = ProgressBar::Base.new(:total => nil)

      expect(Formatter.process(format, 100, progressbar)).to eql ''
    end
  end

  context 'with the %e flag' do
    let(:format) { Format::String.new('%e') }

    it 'is unknown estimated time when called before the bar is started' do
      progressbar = ProgressBar::Base.new

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: ??:??:??'
    end

    it 'is unknown estimated time when the bar is started with any progress' do
      progressbar = ProgressBar::Base.new(:starting_at =>  1)

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: ??:??:??'
    end

    it 'is "??:??:??" when called after the bar is started makes progress and reset' do
      progressbar = ProgressBar::Base.new

      Timecop.freeze(to_the_past) do
        progressbar.start
        progressbar.progress = 50
      end

      progressbar.reset

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: ??:??:??'
    end

    it 'is the estimated time remaining when called after the bar is started' do
      progressbar = ProgressBar::Base.new(:smoothing => 0.0)

      Timecop.freeze(to_the_past) do
        progressbar.start
        progressbar.progress = 50
      end

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: 01:02:03'
    end

    it 'is "??:??:??" when it could take 100 hours or longer to finish' do
      progressbar = ProgressBar::Base.new(:total => 100, :smoothing => 0.0)

      Timecop.freeze(one_hundred_hours_ago) do
        progressbar.start
        progressbar.progress = 50
      end

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: ??:??:??'
    end

    it 'is the total amount of time elapsed once the bar finishes' do
      progressbar = ProgressBar::Base.new(:throttle_rate => 0.0)

      Timecop.freeze(four_minutes_ago) do
        progressbar.start
      end

      Timecop.freeze(one_minute_ago) do
        progressbar.finish
      end

      expect(Formatter.process(format, 100, progressbar)).to eql 'Time: 00:03:00'
    end
  end

  context 'with the %E flag' do
    let(:format) { Format::String.new('%E') }

    it 'is unknown estimated time when called before the bar is started' do
      progressbar = ProgressBar::Base.new

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: ??:??:??'
    end

    it 'is unknown estimated time when the bar is started with any progress' do
      progressbar = ProgressBar::Base.new(:starting_at =>  1)

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: ??:??:??'
    end

    it 'is "??:??:??" when called after the bar is started makes progress and reset' do
      progressbar = ProgressBar::Base.new

      Timecop.freeze(to_the_past) do
        progressbar.start
        progressbar.progress = 50
      end

      progressbar.reset

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: ??:??:??'
    end

    it 'is the estimated time remaining when called after the bar is started' do
      progressbar = ProgressBar::Base.new(:smoothing => 0.0)

      Timecop.freeze(to_the_past) do
        progressbar.start
        progressbar.progress = 50
      end

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: 01:02:03'
    end

    it 'is the total amount of time elapsed once the bar finishes' do
      progressbar = ProgressBar::Base.new(:throttle_rate => 0.0)

      Timecop.freeze(four_minutes_ago) do
        progressbar.start
      end

      Timecop.freeze(one_minute_ago) do
        progressbar.finish
      end

      expect(Formatter.process(format, 100, progressbar)).to eql 'Time: 00:03:00'
    end

    it 'is "> 4 Days" when it could take 100 hours or longer to finish' do
      progressbar = ProgressBar::Base.new(:total => 100, :smoothing => 0.0)

      Timecop.freeze(one_hundred_hours_ago) do
        progressbar.start
        progressbar.progress = 50
      end

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: > 4 Days'
    end
  end

  context 'with the %f flag' do
    let(:format) { Format::String.new('%f') }

    it 'is unknown estimated time when called before the bar is started' do
      progressbar = ProgressBar::Base.new

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: ??:??:??'
    end

    it 'is unknown estimated time when the bar is started with any progress' do
      progressbar = ProgressBar::Base.new(:starting_at =>  1)

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: ??:??:??'
    end

    it 'is "??:??:??" when called after the bar is started makes progress and reset' do
      progressbar = ProgressBar::Base.new

      Timecop.freeze(to_the_past) do
        progressbar.start
        progressbar.progress = 50
      end

      progressbar.reset

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: ??:??:??'
    end

    it 'is the estimated time remaining when called after the bar is started' do
      progressbar = ProgressBar::Base.new(:smoothing => 0.0)

      Timecop.freeze(to_the_past) do
        progressbar.start
        progressbar.progress = 50
      end

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: 01:02:03'
    end

    it 'is the exact estimated time when it could take 100 hours or longer to finish' do
      progressbar = ProgressBar::Base.new(:total => 100, :smoothing => 0.0)

      Timecop.freeze(one_hundred_hours_ago) do
        progressbar.start
        progressbar.progress = 50
      end

      expect(Formatter.process(format, 100, progressbar)).to eql ' ETA: 100:00:00'
    end
  end

  context 'with the %i flag' do
    let(:format) { Format::String.new('%i') }

    it 'is the incomplete space' do
      progressbar = ProgressBar::Base.new(:starting_at => 20)

      expect(Formatter.process(format, 100, progressbar)).to eql(' ' * 80)
    end

    it 'is unknown progress when the bar total is unknown' do
      progressbar = ProgressBar::Base.new(:total => nil)

      expect(Formatter.process(format, 100, progressbar)).to eql '=---' * 25
    end

    it 'is unknown progress when the bar total is unknown and has been incremented' do
      progressbar = ProgressBar::Base.new(:total => nil)
      progressbar.increment

      expect(Formatter.process(format, 100, progressbar)).to eql '-=--' * 25

      progressbar.increment

      expect(Formatter.process(format, 100, progressbar)).to eql '--=-' * 25
    end

    it 'is the custom unknown progress steps if those are specified' do
      progressbar          = ProgressBar::Base.new(
                               :total                            => nil,
                               :unknown_progress_animation_steps => %w{
                                                                      *--
                                                                      -*-
                                                                      --*
                                                                    }
                             )
      progressbar.progress = 2

      expect(Formatter.process(format, 100, progressbar)).to eql "--*-#{'-*-' * 32}"
    end
  end

  context 'with the %j flag' do
    let(:format) { Format::String.new('%j') }

    it 'is the justified percentage complete floored to the nearest whole number' do
      progressbar = ProgressBar::Base.new(:starting_at => 33, :total => 200)

      expect(Formatter.process(format, 100, progressbar)).to eql ' 16'
    end

    it 'is zero when the total is unknown' do
      progressbar = ProgressBar::Base.new(:total => nil)

      expect(Formatter.process(format, 100, progressbar)).to eql '  0'
    end

    it 'is 100% when the total is zero' do
      progressbar = ProgressBar::Base.new(:total => 0)

      expect(Formatter.process(format, 100, progressbar)).to eql '100'
    end
  end

  context 'with the %J flag' do
    let(:format) { Format::String.new('%J') }

    it 'is the justified percentage complete floored to two decimal places' do
      progressbar = ProgressBar::Base.new(:starting_at => 33, :total => 200)

      expect(Formatter.process(format, 100, progressbar)).to eql ' 16.50'
    end

    it 'is zero when the total is unknown' do
      progressbar = ProgressBar::Base.new(:total => nil)

      expect(Formatter.process(format, 100, progressbar)).to eql '   0.0'
    end

    it 'is 100% when the total is zero' do
      progressbar = ProgressBar::Base.new(:total => 0)

      expect(Formatter.process(format, 100, progressbar)).to eql ' 100.0'
    end
  end

  context 'with the %p flag' do
    let(:format) { Format::String.new('%p') }

    it 'is the percentage complete floored to the nearest whole number' do
      progressbar = ProgressBar::Base.new(:starting_at => 33, :total => 200)

      expect(Formatter.process(format, 100, progressbar)).to eql '16'
    end

    it 'is zero when the total is unknown' do
      progressbar = ProgressBar::Base.new(:total => nil)

      expect(Formatter.process(format, 100, progressbar)).to eql '0'
    end

    it 'is 100% when the total is zero' do
      progressbar = ProgressBar::Base.new(:total => 0)

      expect(Formatter.process(format, 100, progressbar)).to eql '100'
    end
  end

  context 'with the %P flag' do
    let(:format) { Format::String.new('%P') }

    it 'is the percentage complete floored to two decimal places' do
      progressbar = ProgressBar::Base.new(:starting_at => 33, :total => 200)

      expect(Formatter.process(format, 100, progressbar)).to eql '16.50'
    end

    it 'is the percentage complete only up to two decimal places' do
      progressbar = ProgressBar::Base.new(:starting_at => 66, :total => 99)

      expect(Formatter.process(format, 100, progressbar)).to eql '66.66'
    end

    it 'is zero when the total is unknown' do
      progressbar = ProgressBar::Base.new(:total => nil)

      expect(Formatter.process(format, 100, progressbar)).to eql '0.0'
    end

    it 'is 100% when the total is zero' do
      progressbar = ProgressBar::Base.new(:total => 0)

      expect(Formatter.process(format, 100, progressbar)).to eql '100.0'
    end
  end

  context 'with the %r flag' do
    let(:format) { Format::String.new('%r') }

    it 'is the rate' do
      progressbar = ProgressBar::Base.new

      Timecop.freeze do
        progressbar.start
        progressbar.progress += 20

        Timecop.freeze(2) do
          expect(Formatter.process(format, 100, progressbar)).to eql '10'
        end
      end
    end

    it 'is zero when no time has elapsed' do
      Timecop.freeze do
        progressbar = ProgressBar::Base.new

        expect(Formatter.process(format, 100, progressbar)).to eql '0'
      end
    end

    it 'is zero when no progress has been made' do
      progressbar = ProgressBar::Base.new(:starting_at => 20)

      Timecop.freeze(2) do
        expect(Formatter.process(format, 100, progressbar)).to eql '0'
      end
    end

    it 'takes the starting position into account' do
      progressbar = ProgressBar::Base.new(:starting_at => 20)

      Timecop.freeze do
        progressbar.start
        progressbar.progress += 20

        Timecop.freeze(2) do
          expect(Formatter.process(format, 100, progressbar)).to eql '10'
        end
      end
    end

    it 'is the rate when a custom rate is used' do
      progressbar = ProgressBar::Base.new(:rate_scale => lambda { |rate| rate / 2 })

      Timecop.freeze do
        progressbar.start
        progressbar.progress += 20

        Timecop.freeze(2) do
          expect(Formatter.process(format, 100, progressbar)).to eql '5'
        end
      end
    end

    it 'is zero when no progress has been made when a custom rate is used' do
      progressbar = ProgressBar::Base.new(:starting_at => 20,
                                          :rate_scale  => lambda { |rate| rate / 2 })

      Timecop.freeze(2) do
        expect(Formatter.process(format, 100, progressbar)).to eql '0'
      end
    end

    it 'takes the starting position into account when a custom rate is used' do
      progressbar = ProgressBar::Base.new(:starting_at => 20,
                                          :rate_scale  => lambda { |rate| rate / 2 })

      Timecop.freeze do
        progressbar.start
        progressbar.progress += 20

        Timecop.freeze(2) do
          expect(Formatter.process(format, 100, progressbar)).to eql '5'
        end
      end
    end
  end

  context 'with the %R flag' do
    let(:format) { Format::String.new('%R') }

    it 'is the rate' do
      progressbar = ProgressBar::Base.new

      Timecop.freeze do
        progressbar.start
        progressbar.progress += 10

        Timecop.freeze(6) do
          expect(Formatter.process(format, 100, progressbar)).to eql '1.67'
        end
      end
    end

    it 'is zero when no time has elapsed' do
      Timecop.freeze do
        progressbar = ProgressBar::Base.new

        expect(Formatter.process(format, 100, progressbar)).to eql '0'
      end
    end

    it 'is zero when no progress has been made' do
      progressbar = ProgressBar::Base.new(:starting_at => 20)

      Timecop.freeze(2) do
        expect(Formatter.process(format, 100, progressbar)).to eql '0.00'
      end
    end

    it 'takes the starting position into account' do
      progressbar = ProgressBar::Base.new(:starting_at => 20)

      Timecop.freeze do
        progressbar.start
        progressbar.progress += 13

        Timecop.freeze(2) do
          expect(Formatter.process(format, 100, progressbar)).to eql '6.50'
        end
      end
    end

    it 'is the rate when a custom rate is used' do
      progressbar = ProgressBar::Base.new(:rate_scale => lambda { |rate| rate / 2 })

      Timecop.freeze do
        progressbar.start
        progressbar.progress += 10

        Timecop.freeze(6) do
          expect(Formatter.process(format, 100, progressbar)).to eql '0.83'
        end
      end
    end

    it 'is zero when no progress has been made when a custom rate is used' do
      progressbar = ProgressBar::Base.new(:starting_at => 20,
                                          :rate_scale  => lambda { |rate| rate / 2 })

      Timecop.freeze(2) do
        expect(Formatter.process(format, 100, progressbar)).to eql '0.00'
      end
    end

    it 'takes the starting position into account when a custom rate is used' do
      progressbar = ProgressBar::Base.new(:starting_at => 20,
                                          :rate_scale  => lambda { |rate| rate / 2 })

      Timecop.freeze do
        progressbar.start
        progressbar.progress += 13

        Timecop.freeze(2) do
          expect(Formatter.process(format, 100, progressbar)).to eql '3.25'
        end
      end
    end
  end

  context 'with the %t flag' do
    let(:format) { Format::String.new('%t') }

    it 'is the title' do
      progressbar = ProgressBar::Base.new

      expect(Formatter.process(format, 100, progressbar)).to eql 'Progress'
    end
  end

  context 'with the %T flag' do
    let(:format) { Format::String.new('%T') }

    it 'is the title' do
      progressbar = ProgressBar::Base.new

      expect(Formatter.process(format, 100, progressbar)).to eql 'Progress'
    end
  end

  context 'with the %u flag' do
    let(:format) { Format::String.new('%u') }

    it 'is "??" when the total is unknown' do
      progressbar = ProgressBar::Base.new(:total => nil)

      expect(Formatter.process(format, 100, progressbar)).to eql '??'
    end
  end

  context 'with the %W flag' do
    let(:format) { Format::String.new('%W') }

    it 'is the bar with percentage (including incomplete space)' do
      progressbar = ProgressBar::Base.new(:length => 100)

      expect(Formatter.process(format, 100, progressbar)).to eql ' ' * 100
      4.times { progressbar.increment }
      expect(Formatter.process(format, 100, progressbar)).to eql "====#{' ' * 96}"
      progressbar.increment
      expect(Formatter.process(format, 100, progressbar)).to eql "= 5 =#{' ' * 95}"
      5.times { progressbar.increment }
      expect(Formatter.process(format, 100, progressbar)).to eql "=== 10 ===#{' ' * 90}"
      progressbar.decrement
      expect(Formatter.process(format, 100, progressbar)).to eql "=== 9 ===#{' ' * 91}"
      91.times { progressbar.increment }
      expect(Formatter.process(format, 100, progressbar)).to \
        eql \
          "#{'=' * 47} 100 #{'=' * 48}"
    end
  end

  context 'with the %w flag' do
    let(:format) { Format::String.new('%w') }

    it 'is the bar with the percentage' do
      progressbar = ProgressBar::Base.new(:length => 100)

      expect(Formatter.process(format, 100, progressbar)).to eql ''
      4.times { progressbar.increment }
      expect(Formatter.process(format, 100, progressbar)).to eql '===='
      progressbar.increment
      expect(Formatter.process(format, 100, progressbar)).to eql '= 5 ='
      5.times { progressbar.increment }
      expect(Formatter.process(format, 100, progressbar)).to eql '=== 10 ==='
      progressbar.decrement
      expect(Formatter.process(format, 100, progressbar)).to eql '=== 9 ==='
      91.times { progressbar.increment }
      expect(Formatter.process(format, 100, progressbar)).to \
        eql \
          "#{'=' * 47} 100 #{'=' * 48}"
    end
  end

  context 'with combined flags' do
    it 'is the whole bar when combining both the bar and incomplete space flags' do
      format      = Format::String.new('%b%i')
      progressbar = ProgressBar::Base.new(:length => 100)

      expect(Formatter.process(format, 100, progressbar)).to eql(' ' * 100)
      4.times { progressbar.increment }
      expect(Formatter.process(format, 100, progressbar)).to eql("====#{' ' * 96}")
      progressbar.increment
      expect(Formatter.process(format, 100, progressbar)).to eql("=====#{' ' * 95}")
      5.times { progressbar.increment }
      expect(Formatter.process(format, 100, progressbar)).to eql("==========#{' ' * 90}")
      progressbar.decrement
      expect(Formatter.process(format, 100, progressbar)).to eql("=========#{' ' * 91}")
      91.times { progressbar.increment }
      expect(Formatter.process(format, 100, progressbar)).to eql('=' * 100)
    end

    it 'is the proper ETA when the bar has an unknown total' do
      unknown_oob_format  = Format::String.new('%i%e')
      friendly_oob_format = Format::String.new('%i%E')
      progressbar         = ProgressBar::Base.new(:total => nil)

      progressbar.increment

      unknown_format_string  = Formatter.process(unknown_oob_format,  100, progressbar)
      friendly_format_string = Formatter.process(friendly_oob_format, 100, progressbar)

      expect(unknown_format_string).to  eql "#{'-=--' * 21}-= ETA: ??:??:??"
      expect(friendly_format_string).to eql "#{'-=--' * 21}-= ETA: ??:??:??"
    end

    it 'is the truncated string when the terminal width is shorter than the string ' \
       'being output and the bar length is calculated' do
      format            = Format::String.new('%t%w')
      progressbar       = ProgressBar::Base.new(:title     => ('*' * 21),
                                                :autostart => false)

      expect(Formatter.process(format, 20, progressbar)).to eql '*********************'
    end

    it 'is the truncated string when the terminal width is shorter than the string ' \
       'being output and the incomplete bar length is calculated' do
      format      = Format::String.new('%t%i')
      progressbar = ProgressBar::Base.new(:title     => ('*' * 21),
                                          :autostart => false)

      expect(Formatter.process(format, 20, progressbar)).to eql '*********************'
    end

    it 'is an empty bar when the terminal width is shorter than the string ' \
        'being output and the full bar length is calculated (but lacks the ' \
        'space to output the entire bar)' do
      format      = Format::String.new('%t%B')
      progressbar = ProgressBar::Base.new(:title     => ('*' * 19),
                                          :autostart => false)

      expect(Formatter.process(format, 20, progressbar)).to eql '******************* '
    end

    it 'is an empty bar when the terminal width is shorter than the string ' \
        'being output and the combination of bar and incomplete length is ' \
        'calculated (but lacks the space to output the entire bar)' do
      format      = Format::String.new('%t%w%i')
      progressbar = ProgressBar::Base.new(:title     => ('*' * 19),
                                          :autostart => false)

      expect(Formatter.process(format, 20, progressbar)).to eql '******************* '
    end

    it 'has the proper negative space when a bar with integrated percentage is used' do
      format      = Format::String.new('%w%i')
      progressbar = ProgressBar::Base.new(:length => 100, :total => 200)

      expect(Formatter.process(format, 100, progressbar)).to eql(' ' * 100)
      progressbar.progress = 9
      expect(Formatter.process(format, 100, progressbar)).to eql "====#{' ' * 96}"
      progressbar.increment
      expect(Formatter.process(format, 100, progressbar)).to eql "= 5 =#{' ' * 95}"
    end
  end

  context 'when format contains ANSI SGR codes' do
    it 'ignores their long versions when calculating bar length' do
      color_code    = "\e[0m\e[32m\e[7m\e[1m"
      reset_code    = "\e[0m"
      progress_mark = "#{color_code} #{reset_code}"
      format        = Format::String.new("#{color_code}Processing... %b%i#{reset_code}" \
                                         "#{color_code} %p%%#{reset_code}")
      progressbar   = ProgressBar::Base.new(:progress_mark => progress_mark)

      progressbar.progress = 75

      expect(Formatter.process(format, 24, progressbar)).to \
        eql \
          "#{color_code}Processing... " \
          "#{progress_mark * 4}#{' ' * 2}#{reset_code}" \
          "#{color_code} 75%#{reset_code}"
    end

    it 'ignores their short versions when calculating bar length' do
      color_code    = "\e[0;32;7;1m"
      reset_code    = "\e[0m"
      progress_mark = "#{color_code} #{reset_code}"
      format        = Format::String.new("#{color_code}Processing... %b%i#{reset_code}" \
                                         "#{color_code} %p%%#{reset_code}")
      progressbar   = ProgressBar::Base.new(:progress_mark => progress_mark)

      progressbar.progress = 75

      expect(Formatter.process(format, 24, progressbar)).to \
        eql \
          "#{color_code}Processing... " \
          "#{progress_mark * 4}#{' ' * 2}#{reset_code}" \
          "#{color_code} 75%#{reset_code}"
    end
  end
end
end
end
