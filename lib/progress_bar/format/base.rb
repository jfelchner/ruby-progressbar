class ProgressBar
  module Format
    class Base
      attr_reader :molecules

      def initialize(format_string)
        @molecules = parse(format_string)
      end

      def non_bar_molecules
        molecules.select { |molecule| !molecule.bar_molecule? }
      end

      def bar_molecules
        molecules.select { |molecule| molecule.bar_molecule? }
      end

    private
      def parse(format_string)
        molecules        = []

        format_string.scan(/%([^%])/) do |match|
          molecules << Molecule.new(match[0])
        end

        molecules
      end
    end
  end
end
