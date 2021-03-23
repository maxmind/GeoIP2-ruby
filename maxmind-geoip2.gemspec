# frozen_string_literal: true

Gem::Specification.new do |s|
  s.authors     = ['William Storey']
  s.files       = Dir['**/*']
  s.name        = 'maxmind-geoip2'
  s.summary     = 'A gem for interacting with the GeoIP2 webservices and databases.'
  s.version     = '0.6.0'

  s.description = 'A gem for interacting with the GeoIP2 webservices and databases. MaxMind provides geolocation data as downloadable databases as well as through a webservice.'
  s.email = 'support@maxmind.com'
  s.homepage    = 'https://github.com/maxmind/GeoIP2-ruby'
  s.licenses    = ['Apache-2.0', 'MIT']
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/maxmind/GeoIP2-ruby/issues',
    'changelog_uri' => 'https://github.com/maxmind/GeoIP2-ruby/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/maxmind-geoip2',
    'homepage_uri' => 'https://github.com/maxmind/GeoIP2-ruby',
    'source_code_uri' => 'https://github.com/maxmind/GeoIP2-ruby',
  }
  s.required_ruby_version = '>= 2.4.0'

  s.add_runtime_dependency 'connection_pool', ['~> 2.2']
  s.add_runtime_dependency 'http', ['~> 4.3']
  s.add_runtime_dependency 'maxmind-db', ['~> 1.1']

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-performance'
  s.add_development_dependency 'webmock'
end
