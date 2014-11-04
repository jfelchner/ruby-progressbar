class   ProgressBar
module  Format
class   String < ::String
  ANSI_SGR_PATTERN = /\e\[[\d;]+m/

  # rubocop:disable Style/MultilineBlockChain, Style/MultilineOperationIndentation
  def each_molecule
    dup.
    each_non_bar_molecule do |molecule, string|
      yield molecule, string
    end.
    each_bar_molecule do |molecule, string|
      yield molecule, string
    end
  end

  def each_non_bar_molecule
    non_bar_molecules.each_with_object(self) do |molecule, string|
      yield molecule, string
    end.
    gsub('%%', '%')
  end
  # rubocop:enable Style/MultilineBlockChain, Style/MultilineOperationIndentation

  def each_bar_molecule
    bar_molecules.each_with_object(self) do |molecule, string|
      yield molecule, string
    end
  end

  def length_available_for_bar(max_length)
    @length_available_for_bar ||= \
      begin
        bar_length = max_length - displayable_length + molecule_placeholder_length

        bar_length < 0 ? 0 : bar_length
      end
  end

  def displayable_length
    @displayable_length ||= gsub(ANSI_SGR_PATTERN, '').length
  end

  def molecule_placeholder_length
    @molecule_placeholder_length ||= scan(/%[a-zA-Z]/).size * 2
  end

  def non_bar_molecules
    @non_bar_molecules ||= molecules.select(&:non_bar_molecule?)
  end

  def bar_molecules
    @bar_molecules ||= molecules.select(&:bar_molecule?)
  end

  def molecules
    @molecules ||= begin
                      molecules = []

                      scan(/%[a-zA-Z]/) do |match|
                        molecules << Molecule.new(match[1, 1])
                      end

                      molecules
                    end
  end
end
end
end
