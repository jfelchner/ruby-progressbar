class ProgressBar
  module Format
    class Molecule
      MOLECULES = {
        :t => :title,
        :T => :title,
        :c => :progress,
        :C => :total,
        :p => :percentage,
        :P => :percentage_with_precision,
        :j => :justified_percentage,
        :J => :justified_percentage_with_precision,
        :a => :elapsed_time,
        :e => :estimated_time_with_unknown_oob,
        :E => :estimated_time_with_friendly_oob,
        :f => :estimated_time_with_no_oob,
        :B => :complete_bar,
        :b => :bar,
        :w => :bar_with_percentage,
        :i => :incomplete_space,
        :r => :rate_of_change,
        :R => :rate_of_change_with_precision,
      }

      BAR_MOLECULES     = %w{w B b i}

      attr_reader   :key
      attr_reader   :method_name

      def initialize(letter)
        @key         = letter
        @method_name = MOLECULES.fetch(@key.to_sym)
      end

      def bar_molecule?
        BAR_MOLECULES.include? @key
      end
    end
  end
end
