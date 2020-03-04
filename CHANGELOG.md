# Changelog

## 0.3.0

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
