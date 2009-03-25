# -*- coding: utf-8 -*-
require 'rubygems'
require 'logger'

class GrowlLogger < Logger
  def initialize(args, &block)
    super(GrowlLogger::IO.new(args[:name] || 'growl-logger', &block))
    self.level = args[:level] || Logger::WARN
    self.datetime_format = args[:datetime_format] || '%X'
    self.formatter = block || 
      lambda do |severity, time, progname, message|
        "#{severity}: #{message}"
      end
  end

  class IO
    def initialize(name, &block)
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
      priority = get_priority(level)
      if @growl
        @growl.notify "log", @name, message, priority
      else
        system 'growlnotify', @name, '-p', priority.to_s, '-m', message
      end
    end

    def get_level(message)
      case message
      when /^D/
        Logger::DEBUG
      when /^I/
        Logger::INFO
      when /^W/
        Logger::WARN
      when /^E/
        Logger::ERROR
      when /^F/
        Logger::FATAL
      else
        Logger::INFO
      end
    end

    def get_priority(level)
      level - 2
    end

    def close;end
  end
end
