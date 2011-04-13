require 'spec_helper'

describe ProgressBar::Format::Molecule do
  describe "#new" do
    before { @molecule = ProgressBar::Format::Molecule.new('e') }

    it "sets the key when initialized" do
      @molecule.key.should eql 'e'
    end

    it "sets the method name when initialized" do
      @molecule.method_name.should eql :estimated_time
    end

    context "when initialized for an item with method arguments" do
      before { @molecule = ProgressBar::Format::Molecule.new('e') }

      it "sets the method arguments when initialized" do
        @molecule.method_arguments.should be_kind_of Array
      end
    end

    context "when initialized for an item without method arguments" do
      before { @molecule = ProgressBar::Format::Molecule.new('b') }

      it "sets the method arguments to nil" do
        @molecule.method_arguments.should be_nil
      end
    end
  end

  describe "#bar_molecule?" do
    it "is true if the molecule's key is a representation of the progress bar graphic" do
      molecule = ProgressBar::Format::Molecule.new('b')
      molecule.should be_bar_molecule
    end
  end
end
