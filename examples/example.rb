# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../lib/growl-logger'

log = GrowlLogger.new :level => Logger::DEBUG, :growlnotify => true

log.debug('debug')
log.info('info')
log.warn('warn')
log.error('error')
log.fatal('fatal')
