module WarningFilter
  class Filter < ::IO
    def initialize(io)
      @io = io

      super()
    end

    def write(line)
      return if warning_from_gem?(line)

      @io.write(line)
    end

    protected

    def warning_from_gem?(line)
      warning?(line) && from_gem?(line)
    end

    def warning?(line)
      line.include?('warning')
    end

    def from_gem?(line)
      Gem.path.any? { |path| line.include?(path) }
    end
  end
end

$stderr = ::WarningFilter::Filter.new($stderr)
