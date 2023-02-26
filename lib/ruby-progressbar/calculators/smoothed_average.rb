class   ProgressBar
module  Calculators
class   SmoothedAverage
  def self.calculate(current_average, new_value_to_average, rate)
    (new_value_to_average * (1.0 - rate)) + (current_average * rate)
  end
end
end
end
