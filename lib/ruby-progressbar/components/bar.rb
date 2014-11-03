###
# UPA = Unknown Progress Animation
#
class   ProgressBar
module  Components
class   Bar
  DEFAULT_PROGRESS_MARK  = '='
  DEFAULT_REMAINDER_MARK = ' '
  DEFAULT_UPA_STEPS      = ['=---', '-=--', '--=-', '---=']

  attr_accessor :progress_mark
  attr_accessor :remainder_mark
  attr_accessor :length
  attr_accessor :progress
  attr_accessor :upa_steps

  def initialize(options = {})
    self.upa_steps      = options[:unknown_progress_animation_steps] || DEFAULT_UPA_STEPS
    self.progress_mark  = options[:progress_mark]  || DEFAULT_PROGRESS_MARK
    self.remainder_mark = options[:remainder_mark] || DEFAULT_REMAINDER_MARK
    self.progress       = options[:progress]
  end

  def to_s(options = { :format => :standard })
    completed_string = send(:"#{options[:format]}_complete_string")

    "#{completed_string}#{empty_string}"
  end

  def integrated_percentage_complete_string
    return standard_complete_string if completed_length < 5

    " #{progress.percentage_completed} ".to_s.center(completed_length, progress_mark)
  end

  def standard_complete_string
    progress_mark * completed_length
  end

  def empty_string
    incomplete_length = (length - completed_length)

    if progress.total.nil?
      current_animation_step    = progress.progress % upa_steps.size
      animation_graphic         = upa_steps[current_animation_step]
      unknown_incomplete_string = animation_graphic * (
                                    (incomplete_length / upa_steps.size) + 2
                                  )

      unknown_incomplete_string[0, incomplete_length]
    else
      remainder_mark * incomplete_length
    end
  end

  def bar(length)
    self.length = length

    standard_complete_string
  end

  def complete_bar(length)
    self.length = length

    to_s
  end

  def incomplete_space(length)
    self.length = length

    empty_string
  end

  def bar_with_percentage(length)
    self.length = length

    integrated_percentage_complete_string
  end

  private

  def completed_length
    (length * progress.percentage_completed / 100).floor
  end
end
end
end
