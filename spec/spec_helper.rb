require 'simplecov'
SimpleCov.start

require 'rspec'

Dir[File.join(File.dirname(__FILE__), "..", "lib", "ruby-progressbar.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "..", "spec", "support", "**", "*.rb")].each {|f| require f}

RSpec.configure do |c|
  c.mock_with :rspec
end