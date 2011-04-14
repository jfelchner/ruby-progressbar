module ProgressBar
  module Formatter
    def format(format_string)
      @format_string = format_string
      @format = ProgressBar::Format::Base.new(format_string)
      process
    end

    private
      def process
        processed_string = @format_string.dup

        @format.non_bar_molecules.each do |molecule|
          processed_string.gsub!("%#{molecule.key}", self.send(molecule.method_name).to_s)
        end

        remaining_molecule_match_data = processed_string.match(/%[^%]/)
        remaining_molecules = remaining_molecule_match_data ? remaining_molecule_match_data.size : 0
        placeholder_length  = remaining_molecules * 2

        leftover_bar_length = length - processed_string.length + placeholder_length

        @format.bar_molecules.each do |molecule|
          processed_string.gsub!("%#{molecule.key}", self.send(molecule.method_name, leftover_bar_length / remaining_molecules).to_s)
        end

        processed_string
      end

      # Format Methods
      def title
        @title
      end

      def current
        @bar.current
      end

      def total
        @bar.total
      end

      def percentage
        @bar.percentage_completed
      end

      def percentage_with_precision
        @bar.percentage_completed_with_precision
      end

      def elapsed_time
        @elapsed_time
      end

      def estimated_time
        @estimated_time.out_of_bounds_time_format = nil
        @estimated_time
      end

      def estimated_time_with_unknown_oob
        @estimated_time.out_of_bounds_time_format = :unknown
        @estimated_time
      end

      def estimated_time_with_friendly_oob
        @estimated_time.out_of_bounds_time_format = :friendly
        @estimated_time
      end

      def bar(length)
        @bar.to_s(length)
      end

      def reversed_bar(length)
        @bar.reverse unless @bar.reversed?
        @bar.to_s(length)
      end
  end
end
