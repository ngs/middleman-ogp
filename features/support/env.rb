# frozen_string_literal: true

PROJECT_ROOT_PATH = File.dirname(File.dirname(File.dirname(__FILE__)))
ENV['TEST'] = 'true'
ENV['TZ'] = 'UTC'
require 'middleman-core'
require 'middleman-blog'
require 'middleman-core/step_definitions'
require File.join(PROJECT_ROOT_PATH, 'lib', 'middleman-ogp')
