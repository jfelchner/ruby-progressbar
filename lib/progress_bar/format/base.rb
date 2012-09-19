class ProgressBar
  module Format
    class Base
      attr_reader :molecules

      def initialize(format_string)
        @format_string = format_string
        @molecules = parse(format_string)
      end

      def process(environment)
        processed_string = @format_string.dup

        non_bar_molecules.each do |molecule|
          processed_string.gsub!("%#{molecule.key}", environment.send(molecule.method_name).to_s)
        end

        remaining_molecule_match_data = processed_string.scan(/%[a-zA-Z]/) || []
        remaining_molecules           = remaining_molecule_match_data.size
        placeholder_length            = remaining_molecules * 2

        processed_string.gsub! '%%', '%'

        leftover_bar_length           = environment.send(:length) - processed_string.length + placeholder_length

        bar_molecules.each do |molecule|
          processed_string.gsub!("%#{molecule.key}", environment.send(molecule.method_name, leftover_bar_length).to_s)
        end

      processed_string
    end

    private
      def non_bar_molecules
        @non_bar_molecules ||= molecules.select { |molecule| !molecule.bar_molecule? }
      end

      def bar_molecules
        @bar_molecules     ||= molecules.select { |molecule| molecule.bar_molecule? }
      end

      def parse(format_string)
        molecules        = []

        format_string.scan(/%[a-zA-Z]/) do |match|
          molecules << Molecule.new(match[1,1])
        end

        molecules
      end
    end
  end
end
