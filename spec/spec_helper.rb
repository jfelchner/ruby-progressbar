require 'mathn'
require 'rspec'
require 'timecop'

Dir[File.join(File.dirname(__FILE__), '..', 'lib', 'ruby-progressbar.rb')].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), '..', 'spec', 'support', '**', '*.rb')].each {|f| require f}
