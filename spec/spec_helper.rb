require 'rspectacular'
require 'warning_filter' if Kernel.respond_to?(:require_relative)

RSpec.configure do |config|
  config.warnings = true
end
