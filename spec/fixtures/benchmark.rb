# bundle exec ruby-prof --printer=graph_html --file=../results.html --require 'ruby-progressbar' --sort=total ./spec/fixtures/benchmark.rb

total = 10000
bar   = ProgressBar.create(:length => 80, :start => 0, :total => total)

total.times do |i|
  bar.increment
  bar.log i
end
