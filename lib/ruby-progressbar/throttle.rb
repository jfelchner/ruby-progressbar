class   ProgressBar
class   Throttle
  attr_accessor :rate,
                :started_at,
                :stopped_at,
                :timer

  def initialize(options = {})
    self.rate       = options.delete(:throttle_rate) { 0.01 } || 0.01
    self.started_at = nil
    self.stopped_at = nil
    self.timer      = options[:timer]
  end

  def choke(options = {})
    force = options.fetch(:force_update_if, false)

    yield if !timer.started? || rate.nil? || force || timer.elapsed_seconds >= rate
  end
end
end
