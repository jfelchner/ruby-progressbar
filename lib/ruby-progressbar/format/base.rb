class ProgressBar
  module Format
    class Base
      attr_reader :molecules

      def initialize(format_string)
        @format_string = format_string
        @molecules     = parse(format_string)
      end

      def process(environment, length)
        processed_string = @format_string.dup
        ansi_sgr_codes   = %r{\e\[[\d;]+m}

        non_bar_molecules.each do |molecule|
          processed_string.gsub!("%#{molecule.key}", environment.instance_variable_get(molecule.method_name[0]).send(molecule.method_name[1]).to_s)
        end

        remaining_molecules = bar_molecules.size
        placeholder_length  = remaining_molecules * 2

        processed_string.gsub! '%%', '%'

        processed_string_length = processed_string.gsub(ansi_sgr_codes, '').length
        leftover_bar_length     = length - processed_string_length + placeholder_length
        leftover_bar_length     = leftover_bar_length < 0 ? 0 : leftover_bar_length

        bar_molecules.each do |molecule|
          processed_string.gsub!("%#{molecule.key}", environment.instance_variable_get(molecule.method_name[0]).send(molecule.method_name[1], leftover_bar_length).to_s)
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
