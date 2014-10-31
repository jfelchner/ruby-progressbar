require 'spec_helper'

describe ProgressBar::Throttle do
  let(:timer) { ProgressBar::Timer.new(:time => Time) }

  context 'given a numeric period' do
    before do
      Timecop.freeze(0) {
        @throttle = ProgressBar::Throttle.new(:throttle_rate => 10,
                                                          :timer         => timer)
      }
    end

    describe '#choke' do
      it 'yields the first time' do
        yielded = false

        @throttle.choke { yielded = true; timer.start }

        expect(yielded).to eql true
      end

      context 'after initial yield', :time_mock do
        before do
          @throttle.choke { timer.start }
        end

        it "doesn't yield if period hasn't passed yet" do
          yielded = false

          (1..9).each do |t|
            Timecop.freeze(t) { @throttle.choke { yielded = true; timer.start } }

            expect(yielded).to eql false
          end
        end

        it 'always yields if passed true' do
          yielded = -1

          (0..25).each do |t|
            Timecop.freeze(t) { @throttle.choke(true) { yielded += 1; timer.start } }

            expect(yielded).to eql t
          end
        end

        it "yields after period has passed" do
          yielded = false

          Timecop.freeze(15) { @throttle.choke { yielded = true; timer.start } }

          expect(yielded).to eql true
        end
      end

      context 'after a yield' do
        before do
          Timecop.freeze(0) { @throttle.choke { timer.start } }
          Timecop.freeze(15) { @throttle.choke { timer.start } }
        end

        it "doesn't yield if period hasn't passed yet" do
          yielded = false

          (16..24).each do |t|
            Timecop.freeze(t) { @throttle.choke { yielded = true; timer.start } }

            expect(yielded).to eql false
          end
        end

        it "yields after period has passed" do
          yielded = false

          Timecop.freeze(25) { @throttle.choke { yielded = true; timer.start } }

          expect(yielded).to eql true
        end
      end
    end
  end

  context 'given no throttle period' do
    before do
      Timecop.freeze(0) {
        @throttle = ProgressBar::Throttle.new(:timer => timer)
      }
    end

    describe '#choke' do
      it 'yields every time' do
        yielded = -1

        (0..25).each do |t|
          Timecop.freeze(t) { @throttle.choke { yielded += 1; timer.start } }

          expect(yielded).to eql t
        end
      end
    end
  end
end
