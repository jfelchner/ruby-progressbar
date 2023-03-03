require 'ruby-progressbar/calculators/smoothed_average'

class   ProgressBar
class   Projector
  DEFAULT_PROJECTOR     = ProgressBar::Calculators::SmoothedAverage
  NAME_TO_PROJECTOR_MAP = {
    'smoothed' => ProgressBar::Calculators::SmoothedAverage
  }.freeze

  def self.from_type(name)
    NAME_TO_PROJECTOR_MAP.fetch(name, DEFAULT_PROJECTOR)
  end
end
end
