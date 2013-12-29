require 'spec_helper'

describe ProgressBar::Components::Bar do
  context 'when a new bar is created' do
    context 'and no parameters are passed' do
      before { @progressbar = ProgressBar::Components::Bar.new }

      describe '#total' do
        it 'returns the default total' do
          @progressbar.total.should eql ProgressBar::Components::Bar::DEFAULT_TOTAL
        end
      end

      describe '#progress_mark' do
        it 'returns the default mark' do
          @progressbar.progress_mark.should eql ProgressBar::Components::Bar::DEFAULT_PROGRESS_MARK
        end
      end

      describe '#remainder_mark' do
        it 'returns the default remainder mark' do
          @progressbar.remainder_mark.should eql ProgressBar::Components::Bar::DEFAULT_REMAINDER_MARK
        end
      end

      context 'and the bar has not been started' do
        describe '#progress' do
          it 'returns the default beginning position' do
            @progressbar.progress.should be_zero
          end
        end
      end

      context 'and the bar has been started with no starting value given' do
        before { @progressbar.start }

        describe '#progress' do
          it 'returns the default starting value' do
            @progressbar.progress.should eql ProgressBar::Components::Progressable::DEFAULT_BEGINNING_POSITION
          end
        end
      end

      context 'and the bar has been started with a starting value' do
        before { @progressbar.start :at => 10 }

        describe '#progress' do
          it 'returns the given starting value' do
            @progressbar.progress.should eql 10
          end
        end
      end
    end

    context 'and options are passed' do
      before { @progressbar = ProgressBar::Components::Bar.new(:total => 12, :progress_mark => 'x', :remainder_mark => '.') }

      describe '#total' do
        it 'returns the overridden total' do
          @progressbar.total.should eql 12
        end
      end

      describe '#progress_mark' do
        it 'returns the overridden mark' do
          @progressbar.progress_mark.should eql 'x'
        end
      end

      describe '#remainder_mark' do
        it 'returns the overridden mark' do
          @progressbar.remainder_mark.should eql '.'
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
        @progressbar.percentage_completed.should eql 0
      end
    end

    describe '#to_s' do
      it 'displays the bar with no indication of progress' do
        @progressbar.to_s.should eql '                                                                                                    '
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
        @progressbar.progress.should eql 1
      end

      describe '#percentage_completed' do
        it 'calculates the amount completed' do
          @progressbar.percentage_completed.should eql 2
        end
      end

      describe '#to_s' do
        it 'displays the bar with an indication of progress' do
          @progressbar.to_s.should eql '==                                                                                                  '
        end
      end
    end

    describe '#percentage_completed' do
      it 'is zero' do
        @progressbar.percentage_completed.should eql 0
      end
    end

    describe '#to_s' do
      it 'displays the bar with no indication of progress' do
        @progressbar.to_s.should eql '                                                                                                    '
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
        @progressbar.percentage_completed.should eql 0
      end
    end

    describe '#to_s' do
      it 'displays the bar with no indication of progress' do
        @progressbar.to_s.should eql '                                                                                                    '
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
        @progressbar.progress.should eql 50
        @progressbar.percentage_completed.should eql 100
      end

      describe '#to_s' do
        it 'displays the bar as 100% complete' do
          @progressbar.to_s.should eql '=' * 100
        end
      end
    end

    context 'and the bar is decremented' do
      before { @progressbar.decrement }

      it 'removes some progress from the bar' do
        @progressbar.progress.should eql 49
        @progressbar.percentage_completed.should eql 98
      end

      describe '#to_s' do
        it 'displays the bar as 98% complete' do
          @progressbar.to_s.should eql "#{'=' * 98}  "
        end
      end
    end

    describe '#to_s' do
      it 'displays the bar as 100% complete' do
        @progressbar.to_s.should eql ('=' * 100)
      end
    end
  end

  context "when attempting to set the bar's current value to be greater than the total" do
    describe '#new' do
      it 'raises an error' do
        @progressbar = ProgressBar::Components::Bar.new(:total => 10)
        lambda { @progressbar.start :at => 11 }.should raise_error(ProgressBar::InvalidProgressError, "You can't set the item's current value to be greater than the total.")
      end
    end
  end
end
