class ProgressBar
  module Enumerator
    refine ::Enumerator do
      def with_progressbar(options={}, &block)
        chain = ::Enumerator.new do |y|
          progressBar = ProgressBar.create({:total => size}.merge(options))
          each do |*args|
            (y.yield *args).tap { progressBar.increment }
          end
        end
        if block_given?
          chain.each &block
        else
          chain
        end
      end
    end
  end
end if (eval "module Test ; refine Object do ; end ; end" rescue nil)
