class  ProgressBar
module Refinements
module Enumerator
refine ::Enumerator do
  def with_progressbar(options = {}, &block)
    progress_bar = ProgressBar.create(options.merge(:starting_at => 0, :total => size))

    each do |item|
      progress_bar.increment

      next unless block

      yielded_args = []
      yielded_args << item

      yield(*yielded_args)
    end
  end
end
end
end
end
