###
# UPA = Unknown Progress Animation
#
class   ProgressBar
module  Components
class   Bar
  DEFAULT_PROGRESS_MARK     = '='
  DEFAULT_INTERMEDIATE_MARK = '-'
  DEFAULT_REMAINDER_MARK    = ' '
  DEFAULT_UPA_STEPS         = ['=---', '-=--', '--=-', '---=']

  attr_accessor :progress_mark,
                :intermediate_mark,
                :remainder_mark,
                :length,
                :progress,
                :upa_steps

  def initialize(options = {})
    self.upa_steps         = options[:unknown_progress_animation_steps] || DEFAULT_UPA_STEPS
    self.progress_mark     = options[:progress_mark] || DEFAULT_PROGRESS_MARK
    self.intermediate_mark = options[:intermediate_mark] || DEFAULT_INTERMEDIATE_MARK
    self.remainder_mark    = options[:remainder_mark] || DEFAULT_REMAINDER_MARK
    self.progress          = options[:progress]
    self.length            = options[:length]
  end

  def to_s(options = { :format => :precise })
    if progress.unknown?
      unknown_string
    elsif options[:format] == :standard
      "#{standard_complete_string}#{incomplete_string}"
    elsif options[:format] == :integrated_percentage
      "#{integrated_percentage_complete_string}#{incomplete_string}"
    elsif options[:format] == :precise
      "#{precise_complete_string}#{incomplete_string}"
    end
  end

  private

  def full_bar(length)
    self.length = length

    "#{precise_complete_string}#{incomplete_string}"
  end

  def bar(length)
    self.length = length

    precise_complete_string
  end

  def fully_completed_bar(length)
    self.length = length

    standard_complete_string
  end

  def precise_bar(length)
    self.length = length

    to_s(:format => :precise)
  end

  def incomplete_space(length)
    self.length = length

    if progress.unknown?
      unknown_string
    else
      incomplete_string
    end
  end

  def bar_with_percentage(length)
    self.length = length

    integrated_percentage_complete_string
  end

  def unknown_string
    unknown_frame_string = unknown_progress_frame * ((length / upa_steps.size) + 2)

    unknown_frame_string[0, length]
  end

  def precise_completed_length
    (length * progress.percentage_completed / 100.0)
  end

  def fully_completed_length
    precise_completed_length.floor
  end

  def intermediate_completed_length
    (precise_completed_length.round - fully_completed_length).round
  end

  def unknown_progress_frame
    current_animation_step = progress.progress % upa_steps.size

    upa_steps[current_animation_step]
  end

  def integrated_percentage_complete_string
    return standard_complete_string if fully_completed_length < 5

    " #{progress.percentage_completed} ".to_s.center(fully_completed_length, progress_mark)
  end

  def standard_complete_string
    progress_mark * fully_completed_length
  end

  def precise_complete_string
    intermediate_bar = intermediate_mark * intermediate_completed_length

    standard_complete_string + intermediate_bar
  end

  def incomplete_string
    remainder_mark * (length - fully_completed_length - intermediate_completed_length)
  end
end
end
end
