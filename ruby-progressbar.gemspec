# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-progressbar/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-progressbar'
  spec.version       = ProgressBar::VERSION
  spec.authors       = ['thekompanee', 'jfelchner']
  spec.email         = ['support@thekompanee.com']
  spec.summary       = %q{Ruby/ProgressBar is a flexible text progress bar library for Ruby.}
  spec.description   = %q{Ruby/ProgressBar is an extremely flexible text progress bar library for Ruby. The output can be customized with a flexible formatting system including: percentage, bars of various formats, elapsed time and estimated time remaining.}
  spec.homepage      = 'https://github.com/jfelchner/ruby-progressbar'
  spec.license       = 'MIT'

  spec.cert_chain    = %w{certs/jfelchner.pem}
  spec.signing_key   = File.expand_path('~/.gem/certs/jfelchner-private_key.pem') if $0 =~ /gem\z/

  spec.executables   = []
  spec.files         = Dir['{app,config,db,lib/ruby-progressbar}/**/*'] + %w{lib/ruby-progressbar.rb Rakefile README.md LICENSE.txt}

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.add_development_dependency 'rspec', ["~> 3.2"]
  spec.add_development_dependency 'rspectacular', ["~> 0.70.6"]
  spec.add_development_dependency 'fuubar', ["~> 2.0"]
  spec.add_development_dependency 'warning_filter', ["~> 0.0.6"]
  spec.add_development_dependency 'timecop', ["= 0.6.1"]
end
