require 'rspectacular'
require "#{Dir.pwd}/spec/support/warning_filter"
require "#{Dir.pwd}/spec/support/time"

RSpec.configure do |config|
  config.warnings = true
end
