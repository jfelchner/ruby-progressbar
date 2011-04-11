module ProgressBar
  module Format
    class Molecule
      MOLECULES = {
        :t => [:left_justified_title,  :title],
        :T => [:right_justified_title, :title],
        :b => [:bar,                   :bar]
        # :elapsed_time                     => "%a",
        # :estimated_time_with_unknown      => "%e",
        # :estimated_time_with_greater_than => "%E",
        # :force_estimated_time             => "%f",
        # :percentage_complete_as_integer   => "%p",
        # :percentage_complete_as_float     => "%P",
        # :current_capacity                 => "%c",
        # :total_capacity                   => "%C",
        # :bar_with_percentage              => "%B",
        # :reversed_bar                     => "%r",
        # :reversed_bar_with_percentage     => "%R"
      }

      BAR_MOLECULES     = %w{b}

      attr_reader   :key
      attr_reader   :method_name

      def initialize(letter)
        @key                       = letter
        @description, @method_name = MOLECULES[@key.to_sym]
      end

      def bar_molecule?
        BAR_MOLECULES.include? @key
      end
    end
  end
end
