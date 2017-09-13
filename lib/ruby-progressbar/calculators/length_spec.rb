require 'rspectacular'
require 'ruby-progressbar/calculators/length'

class     ProgressBar
module    Calculators
describe  Length do
  if RUBY_PLATFORM != 'java' &&
     Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('1.9.3')

    it 'can properly calculate the length even if IO.console is nil' do
      calculator = Length.new

      expect(IO).to         receive(:console).and_return nil
      expect(calculator).to receive(:dynamic_width_via_system_calls).and_return 123_456

      expect(calculator.calculate_length).to eql 123_456
    end
  end
end
end
end
