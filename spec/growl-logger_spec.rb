# -*- coding: utf-8 -*-

require 'logger'
require File.dirname(__FILE__) + '/../lib/growl-logger'

log = Logger.new(GrowlLogger.new)
log.level = Logger::DEBUG
log.datetime_format = '%X'

log.debug('debug test')
log.info('info test')
log.warn('warn test')
log.error('error test')
log.fatal('fatal test')
