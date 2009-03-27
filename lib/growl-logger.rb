# -*- coding: utf-8 -*-
require 'rubygems'
require 'logger'

class GrowlLogger < Logger
  VERSION = '0.1.3'

  def initialize(args = {})
    super(GrowlLogger::LogDevice.new(
      args[:name] || 'growl-logger',
      args[:host] || 'localhost',
      args[:growlnotify] || false
    ))
    self.level = args[:level] if args[:level]
    self.datetime_format = args[:datetime_format] || '%X'
    self.formatter = lambda { |severity, time, progname, message| "#{severity}: #{message}" }
  end

  class LogDevice
    def initialize(name, host, growlnotify_mode = true, &block)
      @name = name
      @growlnotify_mode = growlnotify_mode
      unless @growlnotify_mode
        begin
          require 'ruby-growl'
          @growl = Growl.new host, @name, ["log"]
        rescue LoadError
        end
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
