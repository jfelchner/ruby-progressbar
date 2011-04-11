module ProgressBar
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

          format_string.scan(/%([tTb])/) do |match|
            molecules << Molecule.new(match[0])
          end

          molecules
        end

    # @title_width      = 14
    # @format           = "%-#{@title_width}s %3d%% %s %s"
    # @format_arguments = [:title, :percentage, :bar, :stat]

    # def format=(format)
      # @format = format
    # end

    # def format_arguments=(arguments)
      # @format_arguments = arguments
    end
  end
end
