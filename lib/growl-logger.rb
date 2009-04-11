# -*- coding: utf-8 -*-
require 'rubygems'
require 'logger'

class GrowlLogger < Logger
  VERSION = '0.2.0'

  def initialize(args = {})
    super(GrowlLogger::LogDevice.new(
      args[:name] || 'growl-logger',
      args[:host] || 'localhost',
      :mode => args[:mode],
      :editor => args[:editor]
    ))
    self.level = args[:level] if args[:level]
    self.datetime_format = args[:datetime_format] || '%X'
    self.formatter = lambda { |severity, time, progname, message| "#{severity}: #{message}" }
  end

  class LogDevice
    def initialize(name, host, options = {}, &block)
      @name = name
      @mode = options[:mode] ? options[:mode].to_sym : nil
      @editor = options[:editor] || 'mate -l'
      unless @mode.to_s == 'growlnotify'
        begin
          require 'meow'
          @meow = Meow.new('log')
        rescue LoadError
        end
        unless @meow
          begin
            require 'ruby-growl'
            @growl = Growl.new host, @name, ["log"]
          rescue LoadError
          end
        end
      end
      @formatter = block if block_given?
    end

    def write(message)
      priority = get_priority(message)
      case @mode
      when :meow
        notify_by_meow(message, priority)
      when :'ruby-growl'
        notify_by_rubygrowl(message, priority)
      when :growlnotify
        notify_by_growlnotify(message, priority)
      else
        if @meow then notify_by_meow(message, priority)
        elsif @growl then notify_by_rubygrowl(message, priority)
        else notify_by_growlnotify(message, priority)
        end
      end
    end

    def notify_by_meow(message, priority)
      call_point = caller.last
      line_number = call_point[/\d+$/]
      file_name = call_point.sub(/:\d+$/, '')
      @meow.notify @name, message, :priority => priority do
        system *(@editor.split(/\s/) + [line_number, File.expand_path(file_name)])
      end
    end

    def notify_by_rubygrowl(message, priority)
      @growl.notify "log", @name, message, priority
    end

    def notify_by_growlnotify(message, priority)
      system 'growlnotify', @name, '-p', priority.to_s, '-m', message
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
