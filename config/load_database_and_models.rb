# frozen_string_literal: true

require 'sqlite3'
require 'active_record'

#
# Config
#
require File.join(__dir__, 'db', 'schedule')
require File.join(__dir__, 'db', 'schedule_candidate')

#
# Models
#
require File.join(__dir__, '..', 'lib', 'models', 'schedule')
require File.join(__dir__, '..', 'lib', 'models', 'schedule_candidate')
