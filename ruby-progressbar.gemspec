Gem::Specification.new do |s|
  s.name = "chalofa_ruby-progressbar"
  s.version = "0.0.9.1"

  s.author = "Satoru Takabayashi"
  s.date = "2011-03-07"
  s.description = "Ruby/ProgressBar is a text progress bar library for Ruby."
  s.email = "satoru@namazu.org"
  s.files = %w[GPL_LICENSE RUBY_LICENSE README.md lib/progressbar.rb test.rb]
  s.homepage = "http://github.com/nex3/ruby-progressbar"
  s.require_paths = ["lib"]
  s.summary = <<END
Ruby/ProgressBar is a text progress bar library for Ruby.
It can indicate progress with percentage, a progress bar,
and estimated remaining time.
Patched to use with Spork by @chalofa...
END
end
