require 'rspectacular'
require 'rspec'
require 'ruby-progressbar/output'

class           ProgressBar
RSpec.describe  Output do
  it "uses tty output if running on terminal shell emulator" do
    allow($stdout).to receive(:tty?).and_return(false)
    allow(ENV).to receive(:[]).and_return(false)
    allow(ENV).to receive(:[]).with('TERM').and_return('xterm-256color')
    allow(ENV).to receive(:[]).with('SHELL').and_return('/bin/bash')
    expect(ProgressBar::Output.detect(output: $stdout)).to be_an_instance_of(ProgressBar::Outputs::Tty)
  end
end
end
