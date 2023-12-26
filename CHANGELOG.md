# Changelog

## 1.3.0

* Ruby 2.5 and 2.6 are no longer supported. If you're using one of these
  versions, please use version 1.2.0 of this gem.

## 1.2.0 (2023-12-04)

* `MaxMind::GeoIP2::Client` now validates the IP address before making a
  request to the web service.
* `MaxMind::GeoIP2::Client` now includes the version of Ruby, the version
  of the HTTP client library, and its own version in the User-Agent header.
* The `anycast?` method was added to `MaxMind::GeoIP2::Record::Traits`.
  This returns `true` if the IP address belongs to an [anycast
  network](https://en.wikipedia.org/wiki/Anycast). This is available for
  the GeoIP2 Country, City Plus, and Insights web services and the GeoIP2
  Country, City, and Enterprise databases.

## 1.1.0 (2021-11-18)

* Exceptions from this gem now inherit from `MaxMind::GeoIP2::Error`. IP
  address related exceptions now inherit from
  `MaxMind::GeoIP2::AddressError`, which itself inherits from
  `MaxMind::GeoIP2::Error`. Pull Request by gr8bit. GitHub #35.
* Support for mobile country code (MCC) and mobile network codes (MNC) was
  added for the GeoIP2 ISP and Enterprise databases as well as the GeoIP2
  City and Insights web services. `mobile_country_code` and
  `mobile_network_code` attributes were added to
  `MaxMind::GeoIP2::Model::ISP` for the GeoIP2 ISP database and
  `MaxMind::GeoIP2::Record::Traits` for the Enterprise database and the
  GeoIP2 City and Insights web services. We expect this data to be
  available by late January, 2022.

## 1.0.0 (2021-05-14)

* Ruby 2.4 is no longer supported. If you're using Ruby 2.4, please use
  version 0.7.0 of this gem.
* Expand accepted versions of the `http` gem to include 5.0+.
* Bump version to 1.0.0 since we have been at 0.x for over a year. There is
  no breaking change.

## 0.7.0 (2021-03-24)

* Ensured defaults are set when creating a `MaxMind::GeoIP2::Client` in the
  case when args are explicitly passed in as `nil`. Pull Request by Manoj
  Dayaram. GitHub #31.

## 0.6.0 (2021-03-23)

* Updated the `MaxMind::GeoIP2::Reader` constructor to support being called
  using keyword arguments. For example, you may now create a `Reader` using
  `MaxMind::GeoIP2::Reader.new(database: 'GeoIP2-Country.mmdb')` instead of
  using positional arguments. This is intended to make it easier to pass in
  optional arguments. Positional argument calling is still supported.
* Proxy support was fixed. Pull request by Manoj Dayaram. GitHub #30.

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
