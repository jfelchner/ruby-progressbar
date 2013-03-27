require 'spec_helper'

# Using ruby-debug under jruby pulls in ruby-debug-base, which defines
# Kernel.start. This causes a bug, as EstimatedTimer::As::method_missing calls
# Kernel.start instead of EstimatedTimer.start. This spec duplicates the bug.
# Without the fix, this results in the following exception:
#
# 1) ruby-debug-base doesn't stop the progressbar from working
#    Failure/Error: COUNT.times { bar.increment }
#    NoMethodError:
#      undefined method `+' for nil:NilClass
#    # ./lib/progress_bar/components/progressable.rb:33:in `increment'

describe 'ruby-debug-base' do

  it "doesn't stop the progressbar from working" do

    module Kernel
      def start(options={}, &block)
        puts "Kernel.start has been called"
        return nil
      end
    end

    COUNT = 100
    bar = ProgressBar.create(:title => 'ruby-debug-base', :total => COUNT)
    COUNT.times { bar.increment }
  end

end
