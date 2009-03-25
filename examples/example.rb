# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../lib/growl-logger'

log = GrowlLogger.new :level => Logger::DEBUG

log.debug('debug test')
log.info('info test')
log.warn('warn test')
log.error('error test')
log.fatal('fatal test')
