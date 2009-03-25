# -*- coding: utf-8 -*-

class GrowlLogger

  def initialize(name = 'growl-logger', &block)
    @name = name
    begin
      require 'ruby-growl'
      @growl = Growl.new "localhost", @name, ["log"]
    rescue LoadError
    end
    @formatter = block if block_given?
  end

  def write(message)
    level = get_level(message)
    message = @formatter.call(level, message) if @formatter
    priority = get_priority(level)
    if @growl
      @growl.notify "log", @name, message, priority
    else
      system 'growlnotify', @name, '-p', priority, '-m', message
    end
  end

  def get_level(message)
    case message
    when /^D,/
      Logger::DEBUG
    when /^I,/
      Logger::INFO
    when /^W,/
      Logger::WARN
    when /^E,/
      Logger::ERROR
    when /^F,/
      Logger::FATAL
    else
      Logger::INFO
    end
  end

  def get_priority(level)
    (level - 2).to_s
  end

  def close;end

end
