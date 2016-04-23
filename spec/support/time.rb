###
# In our specs, I want to make sure time gets mocked so I can accurately test
# times displayed to the user.
#
class PBTimeTester
  def self.now
    ::Time.now
  end
end

class ProgressBar
class Time
  def initialize(time = ::PBTimeTester)
    self.time = time
  end
end
end
