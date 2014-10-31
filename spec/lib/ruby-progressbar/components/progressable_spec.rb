require 'spec_helper'

describe ProgressBar::Components::Progressable do
  context 'when a new progressable is created' do
    before { @progressable = ProgressBar::Components::Progressable.new }

    context 'and no parameters are passed' do
      describe '#total' do
        it 'returns the default total' do
          expect(@progressable.total).to eql ProgressBar::Components::Progressable::DEFAULT_TOTAL
        end
      end

      context 'and the progressable has not been started' do
        describe '#progress' do
          it 'returns the default beginning position' do
            expect(@progressable.progress).to be_zero
          end
        end
      end

      context 'and the progressable has been started with no starting value given' do
        before { @progressable.start }

        describe '#progress' do
          it 'returns the default starting value' do
            expect(@progressable.progress).to eql ProgressBar::Components::Progressable::DEFAULT_BEGINNING_POSITION
          end
        end
      end

      context 'and the progressable has been started with a starting value' do
        before { @progressable.start :at => 10 }

        describe '#progress' do
          it 'returns the given starting value' do
            expect(@progressable.progress).to eql 10
          end
        end
      end
    end

    context 'and options are passed' do
      before { @progressable = ProgressBar::Components::Progressable.new(:total => 12, :progress_mark => 'x', :remainder_mark => '.') }

      describe '#total' do
        it 'returns the overridden total' do
          expect(@progressable.total).to eql 12
        end
      end
    end

    context 'when just begun' do
      before { @progressable.start }

      describe '#percentage_completed' do
        it 'calculates the amount' do
          expect(@progressable.percentage_completed).to eql 0
        end
      end
    end

    context 'when nothing has been completed' do
      before do
        @progressable = ProgressBar::Components::Progressable.new(:total => 50)
        @progressable.start
      end

      context 'and the progressable is incremented' do
        before { @progressable.increment }

        it 'adds to the progress amount' do
          expect(@progressable.progress).to eql 1
        end

        describe '#percentage_completed' do
          it 'calculates the amount completed' do
            expect(@progressable.percentage_completed).to eql 2
          end
        end
      end

      describe '#percentage_completed' do
        it 'is zero' do
          expect(@progressable.percentage_completed).to eql 0
        end
      end
    end

    context 'when a fraction of a percentage has been completed' do
      let(:progress_total) { 200 }

      before do
        @progressable = ProgressBar::Components::Progressable.new(:total => 200)
        @progressable.start :at => 1
      end

      describe '#percentage_completed' do
        it 'always rounds down' do
          expect(@progressable.percentage_completed).to eql 0
        end
      end
    end

    context 'when completed' do
      before do
        @progressable = ProgressBar::Components::Progressable.new(:total => 50)
        @progressable.start :at => 50
      end

      context 'and the bar is incremented' do
        before { @progressable.increment }

        it 'does not increment past the total' do
          expect(@progressable.progress).to eql 50
          expect(@progressable.percentage_completed).to eql 100
        end
      end

      context 'and the bar is decremented' do
        before { @progressable.decrement }

        it 'removes some progress from the bar' do
          expect(@progressable.progress).to eql 49
          expect(@progressable.percentage_completed).to eql 98
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

    it 'is always reset when the progressable is started' do
      subject.running_average = 10
      subject.start :at => 0
      expect(subject.running_average).to be_zero

      subject.start :at => 40
      expect(subject.running_average).to eql 0.0
    end
  end

  describe '#smoothing' do
    it 'can be passed in as an option to the initializer' do
      expect(ProgressBar::Components::Progressable.new(:smoothing => 0.3).smoothing).to eql 0.3
    end

    it 'does not have to be passed in as an option to the initializer' do
      expect(ProgressBar::Components::Progressable.new.smoothing).to eql 0.1
    end
  end

  describe '#percentage_completed' do
    it 'returns the default total if total is zero' do
      subject.total = 0

      expect(subject.percentage_completed).to eql 100
    end
  end
end
