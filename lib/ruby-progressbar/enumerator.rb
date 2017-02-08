class ::Enumerator
  def with_progressbar(**args, &block)
    chain = Enumerator.new do |y|
      progressBar = ProgressBar.create(**{total:size}.merge(args))
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
