# frozen_string_literal: true

PROJECT_ROOT_PATH = File.dirname(File.dirname(__FILE__))

require 'rubygems'
require File.join(PROJECT_ROOT_PATH, 'lib', 'middleman-ogp')
require File.join(PROJECT_ROOT_PATH, 'lib', 'middleman-ogp/extension')

class String
  def unindent
    gsub(/^#{scan(/^\s*/).min_by(&:length)}/, '').sub(/\n$/, '')
  end
end
