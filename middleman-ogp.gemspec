# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'middleman-ogp/version'

Gem::Specification.new do |s|
  s.name = 'middleman-ogp'
  s.version = Middleman::OGP::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Atsushi Nagase']
  s.email = ['a@ngs.io']
  s.homepage = 'https://github.com/ngs/middleman-ogp'
  s.summary = 'OpenGraph Protocol Helper for Middleman'
  s.description = 'OpenGraph Protocol Helper for Middleman'
  s.license = 'MIT'
  s.files = `git ls-files -z`.split("\0")
  s.test_files = `git ls-files -z -- {fixtures,features,spec}/*`.split("\0")
  s.require_paths = ['lib']
  s.add_runtime_dependency('middleman-core', ['>= 4.0'])
end
