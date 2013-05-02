require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'mathn'
require 'rspec'

Dir[File.join(File.dirname(__FILE__), '..', 'lib', 'ruby-progressbar.rb')].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), '..', 'spec', 'support', '**', '*.rb')].each {|f| require f}

require 'rspectacular'
