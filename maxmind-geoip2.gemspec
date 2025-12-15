# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'maxmind/geoip2/version'

Gem::Specification.new do |s|
  s.authors     = ['William Storey']
  s.files       = Dir['**/*'].difference(Dir['.github/**/*', 'dev-bin/**/*', 'test/**/*', 'CLAUDE.md', 'Gemfile*', 'Rakefile', '*.gemspec', 'README.dev.md'])
  s.name        = 'maxmind-geoip2'
  s.summary     = 'A gem for interacting with the GeoIP2 webservices and databases.'
  s.version     = MaxMind::GeoIP2::VERSION

  s.description = 'A gem for interacting with the GeoIP2 webservices and databases. MaxMind provides geolocation data as downloadable databases as well as through a webservice.'
  s.email = 'support@maxmind.com'
  s.homepage    = 'https://github.com/maxmind/GeoIP2-ruby'
  s.licenses    = ['Apache-2.0', 'MIT']
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/maxmind/GeoIP2-ruby/issues',
    'changelog_uri' => 'https://github.com/maxmind/GeoIP2-ruby/blob/main/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/maxmind-geoip2',
    'homepage_uri' => 'https://github.com/maxmind/GeoIP2-ruby',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/maxmind/GeoIP2-ruby',
  }
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'connection_pool', '>= 2.2', '< 4.0'
  s.add_dependency 'http', '>= 4.3', '< 6.0'
  s.add_dependency 'maxmind-db', ['~> 1.4']

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-minitest'
  s.add_development_dependency 'rubocop-performance'
  s.add_development_dependency 'rubocop-rake'
  s.add_development_dependency 'rubocop-thread_safety'
  s.add_development_dependency 'webmock'
end
