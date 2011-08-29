require 'test/unit'
require 'lib/progressbar'

class ProgressBarTest < Test::Unit::TestCase
  SleepUnit = 0.01

  def teardown
    Time.clear_stubs
  end

  def do_make_progress_bar (title, total)
    ProgressBar.new(title, total)
  end

  def test_bytes
    total = 1024 * 1024
    pbar = do_make_progress_bar("test(bytes)", total)
    pbar.file_transfer_mode
    0.step(total, 2**14) {|x|
      pbar.set(x)
      sleep(SleepUnit)
    }
    pbar.finish
  end

  def test_clear
    total = 100
    pbar = do_make_progress_bar("test(clear)", total)
    total.times {
      sleep(SleepUnit)
      pbar.inc
    }
    pbar.clear
    puts
  end

  def test_halt
    total = 100
    pbar = do_make_progress_bar("test(halt)", total)
    (total / 2).times {
      sleep(SleepUnit)
      pbar.inc
    }
    pbar.halt
  end

  def test_inc
    total = 100
    pbar = do_make_progress_bar("test(inc)", total)
    total.times {
      sleep(SleepUnit)
      pbar.inc
    }
    pbar.finish
  end

  def test_inc_x
    total = File.size("lib/progressbar.rb")
    pbar = do_make_progress_bar("test(inc(x))", total)
    File.new("lib/progressbar.rb").each {|line|
      sleep(SleepUnit)
      pbar.inc(line.length)
    }
    pbar.finish
  end

  def test_invalid_set
    total = 100
    pbar = do_make_progress_bar("test(invalid set)", total)
    begin
      pbar.set(200)
    rescue RuntimeError => e
      puts e.message
    end
  end

  def test_set
    total = 1000
    pbar = do_make_progress_bar("test(set)", total)
    (1..total).find_all {|x| x % 10 == 0}.each {|x|
      sleep(SleepUnit)
      pbar.set(x)
    }
    pbar.finish
  end

  def test_slow
    total = 100000
    pbar = do_make_progress_bar("test(slow)", total)
    0.step(500, 1) {|x|
      pbar.set(x)
      sleep(SleepUnit)
    }
    pbar.halt
  end

  def test_total_zero
    total = 0
    pbar = do_make_progress_bar("test(total=0)", total)
    pbar.finish
  end

  def test_alternate_bar
    total = 100
    pbar = do_make_progress_bar("test(alternate)", total)
    pbar.bar_mark = "="
    total.times {
      sleep(SleepUnit)
      pbar.inc
    }
    pbar.finish
  end

  def test_timecop
    offset = 3905
    total = 10000
    pbar = do_make_progress_bar("test(timecop)", total)
    Time.stub(:now_without_mock_time, lambda { Time.now_without_stubbing })
    Time.stub(:now, lambda { Time.now_without_stubbing - offset })
    0.step(500, 1) {|x|
      Time.stub(:now, lambda { Time.now_without_stubbing + offset }) if x == 250
      sleep(SleepUnit)
      pbar.set(x)
    }
    pbar.halt
  end

  def test_delorean
    offset = 3905
    total = 10000
    pbar = do_make_progress_bar("test(delorean)", total)
    Time.stub(:now_without_delorean, lambda { Time.now_without_stubbing })
    Time.stub(:now, lambda { Time.now_without_stubbing - offset })
    0.step(500, 1) {|x|
      Time.stub(:now, lambda { Time.now_without_stubbing + offset }) if x == 250
      sleep(SleepUnit)
      pbar.set(x)
    }
    pbar.halt
  end
end

class ReversedProgressBarTest < ProgressBarTest
  def do_make_progress_bar (title, total)
    ReversedProgressBar.new(title, total)
  end
end

module Stubbing
  def stub(method_name, value=nil)
    stubs[method_name.to_sym] = value
  end

  def clear_stubs
    stubs.clear
  end

  def respond_to?(method_name, include_private=false)
    has_stub?(method_name) || super
  end

  def method_missing(method_name, *args, &blk)
    has_stub?(method_name) ? invoke_stub(method_name) : super
  end

  private

  def stubs
    @stubs ||= {}
  end

  def has_stub?(method_name)
    stubs.keys.include? method_name.to_sym
  end

  def invoke_stub(method_name)
    stub = stubs[method_name]
    stub.respond_to?(:call) ? stub.call : stub
  end
end

class Time
  extend Stubbing

  class << self
    alias_method :now_without_stubbing, :now

    def now
      has_stub?(:now) ? invoke_stub(:now) : now_without_stubbing
    end
  end
end
