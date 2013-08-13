# bundle exec ruby-prof --printer=graph_html --file=../results.html --require 'ruby-progressbar' --sort=total ./spec/fixtures/benchmark.rb

total  = 10
# output = File.open('/Users/jfelchner/Downloads/benchmark.txt', 'w+')
output = $stdout
bar    = ProgressBar.create(:output => output, :length => 80, :start => 0, :total => total)

total.times do |i|
  bar.log i
  bar.increment
end
