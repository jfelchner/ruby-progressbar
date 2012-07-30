require 'spec_helper'

describe ProgressBar::Format::Molecule do
  describe '#new' do
    before { @molecule = ProgressBar::Format::Molecule.new('e') }

    it 'sets the key when initialized' do
      @molecule.key.should eql 'e'
    end

    it 'sets the method name when initialized' do
      @molecule.method_name.should eql :estimated_time_with_unknown_oob
    end
  end

  describe '#bar_molecule?' do
    it "is true if the molecule's key is a representation of the progress bar graphic" do
      molecule = ProgressBar::Format::Molecule.new('B')
      molecule.should be_bar_molecule
    end
  end
end
