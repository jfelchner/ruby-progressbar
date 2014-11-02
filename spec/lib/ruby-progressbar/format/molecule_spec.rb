require 'rspectacular'

describe ProgressBar::Format::Molecule do
  describe '#new' do
    before { @molecule = ProgressBar::Format::Molecule.new('t') }

    it 'sets the key when initialized' do
      expect(@molecule.key).to eql 't'
    end

    it 'sets the method name when initialized' do
      expect(@molecule.method_name).to eql [:@title_comp, :title]
    end
  end

  describe '#bar_molecule?' do
    it "is true if the molecule's key is a representation of the progress bar graphic" do
      molecule = ProgressBar::Format::Molecule.new('B')
      expect(molecule).to be_bar_molecule
    end
  end
end
