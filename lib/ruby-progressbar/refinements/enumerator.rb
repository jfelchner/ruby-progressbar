class  ProgressBar
module Refinements
module Enumerator
refine ::Enumerator do
  def with_progressbar(options = {}, &block)
    progress_bar = ProgressBar.create(options.merge(:starting_at => 0, :total => size))

    each do |*yielded_args|
      progress_bar.increment

      next unless block

      yield(*yielded_args)
    end
  end
end
end
end
end
