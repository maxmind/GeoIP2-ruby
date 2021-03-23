# Changelog

## 0.6.0

* Updated the `MaxMind::GeoIP2::Reader` constructor to support being called
  using keyword arguments. For example, you may now create a `Reader` using
  `MaxMind::GeoIP2::Reader.new(database: 'GeoIP2-Country.mmdb')` instead of
  using positional arguments. This is intended to make it easier to pass in
  optional arguments. Positional argument calling is still supported.
* Bugfix: Fixed proxy support ([#30](https://github.com/maxmind/GeoIP2-ruby/pull/30))

## 0.5.0 (2020-09-25)

* Added the `residential_proxy?` method to
  `MaxMind::GeoIP2::Model::AnonymousIP` and
  `MaxMind::GeoIP2::Record::Traits` for use with the Anonymous IP database
  and GeoIP2 Precision Insights.

## 0.4.0 (2020-03-06)

* HTTP connections are now persistent. There is a new parameter that
  controls the maximum number of connections the client will use.

## 0.3.0 (2020-03-04)

* Modules are now always be defined. Previously we used a shorthand syntax
  which meant including individual classes could leave module constants
  undefined.

## 0.2.0 (2020-02-26)

* Added support for the GeoIP2 Precision web services: Country, City, and
  Insights.

## 0.1.0 (2020-02-20)

* Added support for the Anonymous IP, ASN, Connection Type, Domain, and ISP
  databases.
* Added missing dependency on maxmind-db to the gemspec. Reported by Sean
  Dilda. GitHub #4.

## 0.0.1 (2020-01-09)

* Initial implementation with support for location databases.
