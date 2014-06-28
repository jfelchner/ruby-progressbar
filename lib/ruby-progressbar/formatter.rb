class ProgressBar
  module Formatter
    DEFAULT_FORMAT_STRING         = '%t: |%B|'
    DEFAULT_NON_TTY_FORMAT_STRING = '%t: |%b|'
    DEFAULT_TITLE                 = 'Progress'

    def initialize(options)
      self.format_string = options[:format] || DEFAULT_FORMAT_STRING
      @title             = options[:title]  || DEFAULT_TITLE

      super(options)
    end

    def format(new_format_string = DEFAULT_FORMAT_STRING)
      self.format_string = new_format_string
      @format.process(self)
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
    def format_string=(format_string)
      if @format_string != format_string
        @format_string = format_string
        @format        = ProgressBar::Format::Base.new(format_string)
      end
    end

    # Format Methods
    def title
      @title
    end

    def percentage
      @bar.percentage_completed
    end

    def justified_percentage
      @bar.percentage_completed.to_s.rjust(3)
    end

    def percentage_with_precision
      @bar.percentage_completed_with_precision
    end

    def justified_percentage_with_precision
      @bar.percentage_completed_with_precision.to_s.rjust(6)
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

    def rate_of_change
      @rate.to_s
    end

    def rate_of_change_with_precision
      @rate.to_s("%.2f")
    end
  end
end
