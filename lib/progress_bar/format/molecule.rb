module ProgressBar
  module Format
    class Molecule
      MOLECULES = {
        # :elapsed_time                     => "%a",
        :t => [:left_justified_title,           :title],
        :T => [:right_justified_title,          :title],
        :c => [:current_capacity,               :current],
        :C => [:total_capacity,                 :total],
        :p => [:percentage_complete_as_integer, :percentage],
        :P => [:percentage_complete_as_float,   :percentage_with_precision],
        :b => [:bar,                            :bar]
        # :estimated_time_with_unknown      => "%e",
        # :estimated_time_with_greater_than => "%E",
        # :force_estimated_time             => "%f",
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
