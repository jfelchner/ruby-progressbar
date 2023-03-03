class   ProgressBar
module  Calculators
class   SmoothedAverage
  DEFAULT_STRENGTH = 0.1

  attr_accessor :strength

  def initialize(options = {})
    self.strength = options[:strength] || DEFAULT_STRENGTH
  end

  def calculate(current_projection, new_value)
    self.class.calculate(
      current_projection,
      new_value,
      strength
    )
  end

  def self.calculate(current_projection, new_value, rate)
    (new_value * (1.0 - rate)) + (current_projection * rate)
  end
end
end
end
