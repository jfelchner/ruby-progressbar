require 'spec_helper'

describe ProgressBar::Progress do
  context 'when a new progress is created' do
    before { @progress = ProgressBar::Progress.new }

    context 'and no parameters are passed' do
      describe '#total' do
        it 'returns the default total' do
          expect(@progress.total).to eql ProgressBar::Progress::DEFAULT_TOTAL
        end
      end

      context 'and the progress has not been started' do
        describe '#progress' do
          it 'returns the default beginning position' do
            expect(@progress.progress).to be_zero
          end
        end
      end

      context 'and the progress has been started with no starting value given' do
        before { @progress.start }

        describe '#progress' do
          it 'returns the default starting value' do
            expect(@progress.progress).to eql ProgressBar::Progress::DEFAULT_BEGINNING_POSITION
          end
        end
      end

      context 'and the progress has been started with a starting value' do
        before { @progress.start :at => 10 }

        describe '#progress' do
          it 'returns the given starting value' do
            expect(@progress.progress).to eql 10
          end
        end
      end
    end

    context 'and options are passed' do
      before { @progress = ProgressBar::Progress.new(:total => 12, :progress_mark => 'x', :remainder_mark => '.') }

      describe '#total' do
        it 'returns the overridden total' do
          expect(@progress.total).to eql 12
        end
      end
    end

    context 'when just begun' do
      before { @progress.start }

      describe '#percentage_completed' do
        it 'calculates the amount' do
          expect(@progress.percentage_completed).to eql 0
        end
      end
    end

    context 'when nothing has been completed' do
      before do
        @progress = ProgressBar::Progress.new(:total => 50)
        @progress.start
      end

      context 'and the progress is incremented' do
        before { @progress.increment }

        it 'adds to the progress amount' do
          expect(@progress.progress).to eql 1
        end

        describe '#percentage_completed' do
          it 'calculates the amount completed' do
            expect(@progress.percentage_completed).to eql 2
          end
        end
      end

      describe '#percentage_completed' do
        it 'is zero' do
          expect(@progress.percentage_completed).to eql 0
        end
      end
    end

    context 'when a fraction of a percentage has been completed' do
      let(:progress_total) { 200 }

      before do
        @progress = ProgressBar::Progress.new(:total => 200)
        @progress.start :at => 1
      end

      describe '#percentage_completed' do
        it 'always rounds down' do
          expect(@progress.percentage_completed).to eql 0
        end
      end
    end

    context 'when completed' do
      before do
        @progress = ProgressBar::Progress.new(:total => 50)
        @progress.start :at => 50
      end

      context 'and the bar is incremented' do
        before { @progress.increment }

        it 'does not increment past the total' do
          expect(@progress.progress).to eql 50
          expect(@progress.percentage_completed).to eql 100
        end
      end

      context 'and the bar is decremented' do
        before { @progress.decrement }

        it 'removes some progress from the bar' do
          expect(@progress.progress).to eql 49
          expect(@progress.percentage_completed).to eql 98
        end
      end
    end
  end

  describe '#running_average' do
    it 'is properly calculated when progress has been made' do
      subject.running_average = 10
      subject.start :at => 0
      expect(subject.running_average).to be_zero

      subject.progress += 40
      expect(subject.running_average).to eql 36.0
    end

    it 'is always reset when the progress is started' do
      subject.running_average = 10
      subject.start :at => 0
      expect(subject.running_average).to be_zero

      subject.start :at => 40
      expect(subject.running_average).to eql 0.0
    end
  end

  describe '#smoothing' do
    it 'can be passed in as an option to the initializer' do
      expect(ProgressBar::Progress.new(:smoothing => 0.3).smoothing).to eql 0.3
    end

    it 'does not have to be passed in as an option to the initializer' do
      expect(ProgressBar::Progress.new.smoothing).to eql 0.1
    end
  end

  describe '#percentage_completed' do
    it 'returns the default total if total is zero' do
      subject.total = 0

      expect(subject.percentage_completed).to eql 100
    end
  end
end
