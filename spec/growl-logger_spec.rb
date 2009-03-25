# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/spec_helper'

describe GrowlLogger do
  it 'init' do
    logger = GrowlLogger.new

    logger.level.should == Logger::DEBUG
    logdev = logger.instance_eval{@logdev}.dev
    logdev.class.should == GrowlLogger::LogDevice
    logdev.instance_eval{@name}.should == 'growl-logger'
    logger.datetime_format.should == '%X'
    logger.formatter.call('DEBUG', Time.now, 'foo', 'message').should == "DEBUG: message"
    logdev.instance_eval{@growlnotify_mode}.should == false
  end

  it 'init with name option' do
    logger = GrowlLogger.new :name => 'foo'
    logdev = logger.instance_eval{@logdev}.dev
    logdev.instance_eval{@name}.should == 'foo'
  end

  it 'init with growlnotify option' do
    logger = GrowlLogger.new :growlnotify => true
    logdev = logger.instance_eval{@logdev}.dev
    logdev.instance_eval{@growlnotify_mode}.should == true
  end

  it 'init with datetime_format option' do
    logger = GrowlLogger.new :datetime_format => '%H'
    logger.datetime_format.should == '%H'
  end

  it 'call log' do
    logger = GrowlLogger.new
    logdev = logger.instance_eval{@logdev}.dev
    logdev.should_receive(:write).with('DEBUG: test')
    logger.debug('test')
  end

  it 'call log that under threshold' do
    logger = GrowlLogger.new :level => Logger::WARN
    logdev = logger.instance_eval{@logdev}.dev
    logdev.should_not_receive(:write)
    logger.debug('test')
    logger.info('test')
  end

  it 'get_priority' do
    logdev = GrowlLogger::LogDevice.new('foo')
    logdev.get_priority('DEBUG: test').should == -2
    logdev.get_priority('INFO: test').should  == -1
    logdev.get_priority('WARN: test').should  ==  0
    logdev.get_priority('ERROR: test').should ==  1
    logdev.get_priority('FATAL: test').should ==  2
  end
end
