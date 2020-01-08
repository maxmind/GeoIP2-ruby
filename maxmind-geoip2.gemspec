# frozen_string_literal: true

Gem::Specification.new do |s|
  s.authors     = ['William Storey']
  s.files       = Dir['**/*']
  s.name        = 'maxmind-geoip2'
  s.summary     = 'A gem for interacting with the GeoIP2 webservices and databases.'
  s.version     = '0.0.1'

  s.description = 'A gem for interacting with the GeoIP2 webservices and databases. MaxMind provides geolocation data as downloadable databases as well as through a webservice.'
  s.email = 'support@maxmind.com'
  s.homepage    = 'https://github.com/maxmind/GeoIP2-ruby'
  s.licenses    = ['Apache-2.0', 'MIT']
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/maxmind/GeoIP2-ruby/issues',
    'changelog_uri' => 'https://github.com/maxmind/GeoIP2-ruby/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://github.com/maxmind/GeoIP2-ruby',
    'homepage_uri' => 'https://github.com/maxmind/GeoIP2-ruby',
    'source_code_uri' => 'https://github.com/maxmind/GeoIP2-ruby',
  }
  s.required_ruby_version = '>= 2.4.0'
end
