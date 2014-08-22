# Encoding: utf-8

# rubocop:disable LineLength

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/universal-analytics/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-universal-analytics'
  spec.version       = Rack::UniversalAnalytics::Version
  spec.authors       = ['Michael Deering', 'Matt Barnett']
  spec.email         = ['mdeering@mdeering.com', 'matt@sixtyodd.com']
  spec.summary       = %q(Rack middleware for inserting Google Universal Analytics)
  spec.description   = %q(Rack middleware for inserting Google Universal Analytics and calling its API.)
  spec.homepage      = 'https://github.com/mbarnett/rack-universal-analytics'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('lib/**/*')
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nokogiri'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'

end
