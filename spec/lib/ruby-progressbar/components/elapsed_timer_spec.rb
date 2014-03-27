require 'rspectacular'

describe ProgressBar::Components::ElapsedTimer do
  before { @timer = ProgressBar::Components::ElapsedTimer.new }

  describe '#to_s' do
    context 'when the timer has not been started' do
      it 'displays "Time: --:--:--"' do
        expect(@timer.to_s).to eql 'Time: --:--:--'
      end
    end

    context 'when it has just been started' do
      it 'displays "Time: 00:00:00"' do
        @timer.start
        expect(@timer.to_s).to eql 'Time: 00:00:00'
      end
    end

    context 'when it was started 4 hours, 28 minutes and 13 seconds ago' do
      before do
        Timecop.travel(-16093) do
          @timer.start
        end
      end

      context 'and it was stopped 32 seconds ago' do
        before do
          Timecop.travel(-32) do
            @timer.stop
          end
        end

        context 'and #reset is called' do
          before { @timer.reset }

          it 'displays "Time: --:--:--"' do
            expect(@timer.to_s).to eql 'Time: --:--:--'
          end
        end

        it 'displays "Time: 04:27:41"' do
          expect(@timer.to_s).to eql 'Time: 04:27:41'
        end
      end

      context 'and #reset is called' do
        before { @timer.reset }

        it 'displays "Time: --:--:--"' do
          expect(@timer.to_s).to eql 'Time: --:--:--'
        end
      end

      it 'displays "Time: 04:28:13"' do
        expect(@timer.to_s).to eql 'Time: 04:28:13'
      end
    end
  end

  describe '#stopped?' do
    context 'when the timer is started' do
      before { @timer.start }

      context 'and then it is stopped' do
        before { @timer.stop }

        context 'and then it is restarted' do
          before { @timer.start }

          it 'is false' do
            expect(@timer).not_to be_stopped
          end
        end
      end
    end

    context "when the timer has yet to be started" do
      it 'is false' do
        expect(@timer).not_to be_stopped
      end
    end

    context "when the timer is stopped without having been started" do
      before { @timer.stop }
      it 'is false' do
        expect(@timer).not_to be_stopped
      end
    end
  end
end
