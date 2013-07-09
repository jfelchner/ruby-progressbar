require 'ruby-progressbar'

class ProgressBar
  module WithProgressBar
    def with_progress_bar(options = {}, &block)
      respond_to?(:each) or raise TypeError, 'object needs to implement the each method'
      unless options.key?(:total)
        total_methods = [
          :progress_bar_total, # Define your own total method that is preferredly used
          :size,
          :length,
          :count,
        ]
        total_methods.each do |total_method|
          if respond_to?(total_method) and total = __send__(total_method)
            options[:total] = total
          end
        end
      end
      Thread.current[:__progress_bar__] = ProgressBar.create options
      if block
        each do |x|
          catch :progress_bar_skip do
            block.call(x)
            progress_bar.progress_touched? or progress_bar.increment
            progress_bar.progress_touched = false
          end
        end
        self
      else
        begin
          obj = dup
        rescue TypeError => e
          raise e.class, 'Cannot iterate with progress bar over non-duppable objects'
        end
        def obj.each(&block)
          super do |x|
            catch :progress_bar_skip do
              block.call(x)
              progress_bar.progress_touched? or progress_bar.increment
              progress_bar.progress_touched = false
            end
          end
          self
        end
        obj
      end
    end
  end

  module WithProgressBarThreadLocal
    def progress_bar
      Thread.current[:__progress_bar__]
    end
  end
end

ObjectSpace.each_object(Module) do |m|
  if m <= Enumerable
    m.module_eval do
      include ProgressBar::WithProgressBar
    end
  end
end

class Object
  include ProgressBar::WithProgressBarThreadLocal
end
