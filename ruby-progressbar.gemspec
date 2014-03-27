# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ruby-progressbar/version"

Gem::Specification.new do |s|
  s.rubygems_version      = '1.3.5'

  s.name                  = 'ruby-progressbar'
  s.rubyforge_project     = 'ruby-progressbar'

  s.version               = ProgressBar::VERSION
  s.platform              = Gem::Platform::RUBY

  s.authors               = ["thekompanee", "jfelchner"]
  s.email                 = 'support@thekompanee.com'
  s.date                  = Time.now
  s.homepage              = 'https://github.com/jfelchner/ruby-progressbar'

  s.summary               = 'Ruby/ProgressBar is a flexible text progress bar library for Ruby.'
  s.description           = <<-THEDOCTOR
Ruby/ProgressBar is an extremely flexible text progress bar library for Ruby.
The output can be customized with a flexible formatting system including:
percentage, bars of various formats, elapsed time and estimated time remaining.
THEDOCTOR

  s.rdoc_options          = ['--charset', 'UTF-8']
  s.extra_rdoc_files      = %w[README.md LICENSE]

  #= Manifest =#
  s.files                 = Dir.glob("lib/**/*")
  s.test_files            = Dir.glob("{test,spec,features}/**/*")
  s.executables           = Dir.glob("bin/*").map{ |f| File.basename(f) }
  s.require_paths         = ["lib"]

  s.add_development_dependency('rspec',         '~> 3.0.0beta')
  s.add_development_dependency('rspectacular',              '~> 0.20')
  s.add_development_dependency('fuubar',        '~> 2.0beta')
  s.add_development_dependency('timecop',       '~> 0.6')
  s.add_development_dependency('codeclimate-test-reporter', '~> 0.3.0')
end
