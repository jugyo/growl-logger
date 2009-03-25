# -*- coding: utf-8 -*-
require 'rubygems'
require 'logger'

class GrowlLogger < Logger
  def initialize(args = {})
    super(GrowlLogger::LogDevice.new(args[:name] || 'growl-logger'))
    self.level = args[:level] || Logger::WARN
    self.datetime_format = args[:datetime_format] || '%X'
    self.formatter = lambda do |severity, time, progname, message|
      "#{severity}: #{message}"
    end
  end

  class LogDevice
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
      priority = get_priority(message)
      if @growl
        @growl.notify "log", @name, message, priority
      else
        system 'growlnotify', @name, '-p', priority.to_s, '-m', message
      end
    end

    def get_priority(message)
      case message
      when /^DEBUG/
        -2
      when /^INFO/
        -1
      when /^WARN/
        0
      when /^ERROR/
        1
      when /^FATAL/
        2
      else
        0
      end
    end

    def close;end
  end
end
