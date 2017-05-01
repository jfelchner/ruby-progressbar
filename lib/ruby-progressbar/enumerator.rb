class ::Enumerator
  def with_progressbar(options={}, &block)
    chain = Enumerator.new do |y|
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
end if defined? Enumerator and Enumerator.method_defined? :size
