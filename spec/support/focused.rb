RSpec.configure do |config|
  # Configure RSpec to run focused specs, and also respect the alias 'fit' for focused specs
  config.filter_run       :focused => true
  config.alias_example_to :fit, :focused => true
  config.alias_example_to :pit, :pending => true
  config.run_all_when_everything_filtered = true
end
