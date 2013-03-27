# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "progress_bar/version"
require 'date'

Gem::Specification.new do |s|
  s.rubygems_version      = '1.3.5'

  s.name                  = 'ruby-progressbar'
  s.rubyforge_project     = 'ruby-progressbar'

  s.version               = ProgressBar::VERSION
  s.platform              = Gem::Platform::RUBY

  s.authors               = ["thekompanee", "jfelchner"]
  s.email                 = 'support@thekompanee.com'
  s.date                  = Date.today
  s.homepage              = 'https://github.com/jfelchner/ruby-progressbar'

  s.summary               = 'Ruby/ProgressBar is a flexible text progress bar library for Ruby.'
  s.description           = <<-THEDOCTOR
Ruby/ProgressBar is an extremely flexible text progress bar library for Ruby.
The output can be customized with a flexible formatting system including:
percentage, bars of various formats, elapsed time and estimated time remaining.
THEDOCTOR

  s.rdoc_options          = ["--charset = UTF-8"]
  s.extra_rdoc_files      = %w[README.md LICENSE]

  #= Manifest =#
  # s.default_executable    = 'nothing'
  s.executables           = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files                 = `git ls-files`.split("\n")
  s.test_files            = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths         = ["lib"]
  #= Manifest =#

  s.add_development_dependency('rspec',       '~> 2.11')
  s.add_development_dependency('timecop',     '~> 0.5')
  s.add_development_dependency('simplecov',   '~> 0.5')
  s.add_development_dependency('guard',       '~> 1.4')
  s.add_development_dependency('guard-rspec', '~> 2.1')
  s.add_development_dependency('rb-fsevent',  '~> 0.9')
end
