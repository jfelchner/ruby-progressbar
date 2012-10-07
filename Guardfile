notification  :tmux,
              :success => 'colour22',
              :failed  => 'colour52',
              :display_message => true

guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { 'spec' }
  watch('spec/spec_helper.rb')  { 'spec' }
end
