require 'rspectacular'

describe ProgressBar::Components::Bar do
  context 'when a new bar is created' do
    context 'and no parameters are passed' do
      before { @progressbar = ProgressBar::Components::Bar.new }

      describe '#total' do
        it 'returns the default total' do
          expect(@progressbar.total).to eql ProgressBar::Components::Bar::DEFAULT_TOTAL
        end
      end

      describe '#progress_mark' do
        it 'returns the default mark' do
          expect(@progressbar.progress_mark).to eql ProgressBar::Components::Bar::DEFAULT_PROGRESS_MARK
        end
      end

      describe '#remainder_mark' do
        it 'returns the default remainder mark' do
          expect(@progressbar.remainder_mark).to eql ProgressBar::Components::Bar::DEFAULT_REMAINDER_MARK
        end
      end

      context 'and the bar has not been started' do
        describe '#progress' do
          it 'returns the default beginning position' do
            expect(@progressbar.progress).to be_zero
          end
        end
      end

      context 'and the bar has been started with no starting value given' do
        before { @progressbar.start }

        describe '#progress' do
          it 'returns the default starting value' do
            expect(@progressbar.progress).to eql ProgressBar::Components::Progressable::DEFAULT_BEGINNING_POSITION
          end
        end
      end

      context 'and the bar has been started with a starting value' do
        before { @progressbar.start :at => 10 }

        describe '#progress' do
          it 'returns the given starting value' do
            expect(@progressbar.progress).to eql 10
          end
        end
      end
    end

    context 'and options are passed' do
      before { @progressbar = ProgressBar::Components::Bar.new(:total => 12, :progress_mark => 'x', :remainder_mark => '.') }

      describe '#total' do
        it 'returns the overridden total' do
          expect(@progressbar.total).to eql 12
        end
      end

      describe '#progress_mark' do
        it 'returns the overridden mark' do
          expect(@progressbar.progress_mark).to eql 'x'
        end
      end

      describe '#remainder_mark' do
        it 'returns the overridden mark' do
          expect(@progressbar.remainder_mark).to eql '.'
        end
      end
    end
  end

  context 'when just begun' do
    before do
      @progressbar = ProgressBar::Components::Bar.new(:total => 50)
      @progressbar.length = 100
      @progressbar.start
    end

    describe '#percentage_completed' do
      it 'calculates the amount' do
        expect(@progressbar.percentage_completed).to eql 0
      end
    end

    describe '#to_s' do
      it 'displays the bar with no indication of progress' do
        expect(@progressbar.to_s).to eql '                                                                                                    '
      end
    end
  end

  context 'when nothing has been completed' do
    before do
      @progressbar = ProgressBar::Components::Bar.new(:total => 50)
      @progressbar.length = 100
      @progressbar.start
    end

    context 'and the bar is incremented' do
      before { @progressbar.increment }

      it 'adds to the progress amount' do
        expect(@progressbar.progress).to eql 1
      end

      describe '#percentage_completed' do
        it 'calculates the amount completed' do
          expect(@progressbar.percentage_completed).to eql 2
        end
      end

      describe '#to_s' do
        it 'displays the bar with an indication of progress' do
          expect(@progressbar.to_s).to eql '==                                                                                                  '
        end
      end
    end

    describe '#percentage_completed' do
      it 'is zero' do
        expect(@progressbar.percentage_completed).to eql 0
      end
    end

    describe '#to_s' do
      it 'displays the bar with no indication of progress' do
        expect(@progressbar.to_s).to eql '                                                                                                    '
      end
    end
  end

  context 'when a fraction of a percentage has been completed' do
    before do
      @progressbar = ProgressBar::Components::Bar.new(:total => 200)
      @progressbar.length = 100
      @progressbar.start :at => 1
    end

    describe '#percentage_completed' do
      it 'always rounds down' do
        expect(@progressbar.percentage_completed).to eql 0
      end
    end

    describe '#to_s' do
      it 'displays the bar with no indication of progress' do
        expect(@progressbar.to_s).to eql '                                                                                                    '
      end
    end
  end

  context 'when completed' do
    before do
      @progressbar = ProgressBar::Components::Bar.new(:total => 50)
      @progressbar.length = 100
      @progressbar.start :at => 50
    end

    context 'and the bar is incremented' do
      before { @progressbar.increment }

      it 'does not increment past the total' do
        expect(@progressbar.progress).to eql 50
        expect(@progressbar.percentage_completed).to eql 100
      end

      describe '#to_s' do
        it 'displays the bar as 100% complete' do
          expect(@progressbar.to_s).to eql '=' * 100
        end
      end
    end

    context 'and the bar is decremented' do
      before { @progressbar.decrement }

      it 'removes some progress from the bar' do
        expect(@progressbar.progress).to eql 49
        expect(@progressbar.percentage_completed).to eql 98
      end

      describe '#to_s' do
        it 'displays the bar as 98% complete' do
          expect(@progressbar.to_s).to eql "#{'=' * 98}  "
        end
      end
    end

    describe '#to_s' do
      it 'displays the bar as 100% complete' do
        expect(@progressbar.to_s).to eql ('=' * 100)
      end
    end
  end

  context "when attempting to set the bar's current value to be greater than the total" do
    describe '#new' do
      it 'raises an error' do
        @progressbar = ProgressBar::Components::Bar.new(:total => 10)
        expect { @progressbar.start :at => 11 }.to raise_error(ProgressBar::InvalidProgressError, "You can't set the item's current value to be greater than the total.")
      end
    end
  end
end
