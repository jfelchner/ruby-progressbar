class   ProgressBar
module  Components
class   Spinner
  ANIMATION_FRAMES = [
    "⠋",
    "⠙",
    "⠹",
    "⠸",
    "⠼",
    "⠴",
    "⠦",
    "⠧",
    "⠇",
    "⠏"
  ]

  def initialize(options = {})
    self.progress = options[:progress]
  end

  def spin
    ANIMATION_FRAMES[(progress.progress / 3) % ANIMATION_FRAMES.size]
  end

  protected

  attr_accessor :progress
end
end
end
