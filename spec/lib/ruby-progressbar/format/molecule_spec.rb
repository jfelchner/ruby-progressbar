require 'rspectacular'

describe ProgressBar::Format::Molecule do
  describe '#new' do
    before { @molecule = ProgressBar::Format::Molecule.new('e') }

    it 'sets the key when initialized' do
      expect(@molecule.key).to eql 'e'
    end

    it 'sets the method name when initialized' do
      expect(@molecule.method_name).to eql :estimated_time_with_unknown_oob
    end
  end

  describe '#bar_molecule?' do
    it "is true if the molecule's key is a representation of the progress bar graphic" do
      molecule = ProgressBar::Format::Molecule.new('B')
      expect(molecule).to be_bar_molecule
    end
  end
end
