# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "progress_bar/version"

Gem::Specification.new do |s|
  s.rubygems_version      = '1.3.5'

  s.name                  = 'ruby-progressbar'
  s.rubyforge_project     = 'ruby-progressbar'

  s.version               = ProgressBar::VERSION
  s.platform              = Gem::Platform::RUBY

  s.authors               = ["Satoru Takabayashi", "thekompanee", "jfelchner"]
  s.email                 = 'support@thekompanee.com'
  s.date                  = '2009-02-16'
  s.homepage              = 'http://github.com/nex3/ruby-progressbar'

  s.summary               = 'Ruby/ProgressBar is a text progress bar library for Ruby.'
  s.description           = <<-THEDOCTOR
Ruby/ProgressBar is a text progress bar library for Ruby.
It can indicate progress with percentage, a progress bar,
and estimated remaining time.
THEDOCTOR

  s.rdoc_options          = ["--charset = UTF-8"]
  s.extra_rdoc_files      = %w[README.md RUBY_LICENSE GPL_LICENSE]

  #= Manifest =#
  # s.default_executable    = 'nothing'
  s.executables           = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files                 = `git ls-files`.split("\n")
  s.test_files            = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths         = ["lib"]
  #= Manifest =#

  s.add_development_dependency('bundler',   '~> 1.0.10')
  s.add_development_dependency('rspec',     '~> 2.5.0')
  s.add_development_dependency('timecop',   '~> 0.3.5')
end

