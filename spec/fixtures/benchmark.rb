# bundle exec ruby-prof --printer=graph_html --file=../results.html --require 'ruby-progressbar' --sort=total ./spec/fixtures/benchmark.rb

bar = ProgressBar.create(:length => 80, :start => 0, :total => 100000)

100000.times { bar.increment }
