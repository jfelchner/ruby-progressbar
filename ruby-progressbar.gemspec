# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-progressbar/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-progressbar'
  spec.version       = ProgressBar::VERSION
  spec.authors       = ['thekompanee', 'jfelchner']
  spec.email         = 'support@thekompanee.com'
  spec.summary       = %q{Ruby/ProgressBar is a flexible text progress bar library for Ruby.}
  spec.description   = <<-HEREDOC
Ruby/ProgressBar is an extremely flexible text progress bar library for Ruby.
The output can be customized with a flexible formatting system including:
percentage, bars of various formats, elapsed time and estimated time remaining.
  HEREDOC
  spec.homepage      = 'https://github.com/jfelchner/ruby-progressbar'
  spec.license       = 'MIT'

  spec.executables   = Dir['{bin}/**/*'].map    {|dir| dir.gsub!(/\Abin\//, '')}.
                                         reject {|bin| %w{rails rspec rake setup deploy}}
  spec.files         = Dir['{app,config,db,lib}/**/*'] + %w{Rakefile README.md LICENSE}
  spec.test_files    = Dir['{test,spec,features}/**/*']


  spec.add_development_dependency 'rspec',                      ["~> 3.1"]
  spec.add_development_dependency 'rspectacular',               ["~> 0.21.6"]
  spec.add_development_dependency 'fuubar',                     ["~> 2.0"]
  spec.add_development_dependency 'warning_filter',             ["~> 0.0.2"]
  spec.add_development_dependency 'timecop',                    ["~> 0.6.0"]
  spec.add_development_dependency 'codeclimate-test-reporter',  ["~> 0.3.0"]
end
