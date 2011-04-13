module ProgressBar
  module Formatter
    def format(format_string)
      @format_string = format_string
      @format = ProgressBar::Format::Base.new(format_string)
      process
    end

    def process
      processed_string = @format_string.dup

      @format.non_bar_molecules.each do |molecule|
        value = if molecule.method_arguments
                  self.send(molecule.method_name, *molecule.method_arguments)
                else
                  self.send(molecule.method_name)
                end

        processed_string.gsub!("%#{molecule.key}", value.to_s)
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
  end
end
