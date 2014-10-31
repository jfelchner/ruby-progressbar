require 'spec_helper'

describe ProgressBar::Components::Bar do
  let(:progressable) { ProgressBar::Components::Progressable.new(:total => progress_total) }
  let(:progress_total) { 100 }

  context 'when a new bar is created' do
    context 'and no parameters are passed' do
      before { @progressbar = ProgressBar::Components::Bar.new }

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
    end

    context 'and options are passed' do
      let(:progress_total) { 12 }
      before { @progressbar = ProgressBar::Components::Bar.new(:progress_mark => 'x', :remainder_mark => '.', :progress => progressable) }

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
    let(:progress_total) { 50 }
    before do
      @progressbar = ProgressBar::Components::Bar.new(:progress => progressable)
      @progressbar.length = 100
      progressable.start
    end

    describe '#to_s' do
      it 'displays the bar with no indication of progress' do
        expect(@progressbar.to_s).to eql '                                                                                                    '
      end
    end
  end

  context 'when nothing has been completed' do
    let(:progress_total) { 50 }

    before do
      @progressbar = ProgressBar::Components::Bar.new(:progress => progressable)
      @progressbar.length = 100
      progressable.start
    end

    context 'and the bar is incremented' do
      before { progressable.increment }

      describe '#to_s' do
        it 'displays the bar with an indication of progress' do
          expect(@progressbar.to_s).to eql '==                                                                                                  '
        end
      end
    end

    describe '#to_s' do
      it 'displays the bar with no indication of progress' do
        expect(@progressbar.to_s).to eql '                                                                                                    '
      end
    end
  end

  context 'when a fraction of a percentage has been completed' do
    let(:progress_total) { 200 }
    before do
      @progressbar = ProgressBar::Components::Bar.new(:progress => progressable)
      @progressbar.length = 100
      progressable.start :at => 1
    end

    describe '#to_s' do
      it 'displays the bar with no indication of progress' do
        expect(@progressbar.to_s).to eql '                                                                                                    '
      end
    end
  end

  context 'when completed' do
    let(:progress_total) { 50 }
    before do
      @progressbar = ProgressBar::Components::Bar.new(:progress => progressable)
      @progressbar.length = 100
      progressable.start :at => 50
    end

    context 'and the bar is incremented' do
      before { progressable.increment }

      describe '#to_s' do
        it 'displays the bar as 100% complete' do
          expect(@progressbar.to_s).to eql '=' * 100
        end
      end
    end

    context 'and the bar is decremented' do
      before { progressable.decrement }

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
      let(:progress_total) { 10 }

      it 'raises an error' do
        @progressbar = ProgressBar::Components::Bar.new(:progress => progressable)
        expect { progressable.start :at => 11 }.to raise_error(ProgressBar::InvalidProgressError, "You can't set the item's current value to be greater than the total.")
      end
    end
  end
end
