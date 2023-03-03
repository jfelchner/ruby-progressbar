class   ProgressBar
module  Calculators
class   SmoothedAverage
  DEFAULT_STRENGTH = 0.1

  attr_accessor :strength
  attr_reader   :projection

  def initialize(options = {})
    self.projection = 0.0
    self.strength   = options[:strength] || DEFAULT_STRENGTH
  end

  def start(_options = {})
    self.projection = 0.0
  end

  def calculate(new_value)
    self.projection = \
      self.class.calculate(
        @projection,
        new_value,
        strength
      )
  end

  def self.calculate(current_projection, new_value, rate)
    (new_value * (1.0 - rate)) + (current_projection * rate)
  end

  protected

  attr_writer :projection
end
end
end
