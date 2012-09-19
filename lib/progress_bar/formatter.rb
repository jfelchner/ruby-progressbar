class ProgressBar
  module Formatter
    DEFAULT_FORMAT_STRING = '%t: |%B|'
    DEFAULT_TITLE         = 'Progress'

    def initialize(options)
      @title         = options[:title]  || DEFAULT_TITLE
      self.format_string = options[:format] || DEFAULT_FORMAT_STRING

      super(options)
    end

    def format(new_format_string = DEFAULT_FORMAT_STRING)
      self.format_string = new_format_string
      process
    end

    def title=(title)
      @title = title
    end

    def progress
      @bar.progress
    end

    def total
      @bar.total
    end

  private
    def process
      @format_string.dup.tap do |processed_string|
        @format.non_bar_molecules.each do |molecule|
          processed_string.gsub!("%#{molecule.key}", self.send(molecule.method_name).to_s)
        end

        remaining_molecule_match_data = processed_string.scan(/%[a-zA-Z]/) || []
        remaining_molecules           = remaining_molecule_match_data.size
        placeholder_length            = remaining_molecules * 2

        processed_string.gsub! '%%', '%'

        leftover_bar_length           = length - processed_string.length + placeholder_length

        @format.bar_molecules.each do |molecule|
          processed_string.gsub!("%#{molecule.key}", self.send(molecule.method_name, leftover_bar_length).to_s)
        end
      end
    end

    def format_string=(format_string)
      @format_string = format_string
      @format        = ProgressBar::Format::Base.new(format_string)
    end

    # Format Methods
    def title
      @title
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

    def estimated_time_with_no_oob
      @estimated_time.out_of_bounds_time_format = nil
      estimated_time
    end

    def estimated_time_with_unknown_oob
      @estimated_time.out_of_bounds_time_format = :unknown
      estimated_time
    end

    def estimated_time_with_friendly_oob
      @estimated_time.out_of_bounds_time_format = :friendly
      estimated_time
    end

    def bar(length)
      @bar.length = length
      @bar.standard_complete_string
    end

    def complete_bar(length)
      @bar.length = length
      @bar.to_s
    end

    def incomplete_space(length)
      @bar.length = length
      @bar.empty_string
    end

    def bar_with_percentage(length)
      @bar.length = length
      @bar.integrated_percentage_complete_string
    end

    def estimated_time
      finished? ? @elapsed_time : @estimated_time
    end
  end
end
