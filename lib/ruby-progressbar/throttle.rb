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
    self.timer      = options.fetch(:throttle_timer, Timer.new)
  end

  def choke(options = {})
    force = options.fetch(:force_update_if, false)

    if !timer.started? ||
       rate.nil?       ||
       force           ||
       timer.elapsed_seconds >= rate

      timer.restart

      yield
    end
  end
end
end
