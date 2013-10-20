$:.push File.expand_path('../lib', __FILE__)
require 'guard/ecukes/version'

Gem::Specification.new do |s|
  s.name        = 'guard-ecukes'
  s.version     = Guard::EcukesVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Dillon Kearns']
  s.email       = ['dillon@dillonkearns.com']
  s.homepage    = 'http://github.com/dillonkearns/guard-ecukes'
  s.summary     = 'Guard plugin for the Emacs Ecukes integration testing framework'
  s.description = 'Guard::Ecukes automatically runs your features (much like autotest)'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_dependency 'guard',       '>= 1.1.0'

  s.add_development_dependency 'bundler', '~> 1.1'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.require_path = 'lib'
end
