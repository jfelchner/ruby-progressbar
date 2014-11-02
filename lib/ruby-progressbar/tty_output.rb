require 'ruby-progressbar/output'

class ProgressBar
  class TtyOutput < Output
    DEFAULT_FORMAT_STRING = '%t: |%B|'

    alias_method :update_with_format_change, :with_update

    def clear
      stream.print clear_string
      stream.print "\r"
    end

    def bar_update_string
      bar.to_s
    end

    def eol
      bar.stopped? ? "\n" : "\r"
    end
  end
end
