# GeoIP2 Ruby API

## Description

This is the Ruby API for the GeoIP2 and GeoLite2
[webservices](https://dev.maxmind.com/geoip/docs/web-services?lang=en)
and [databases](https://dev.maxmind.com/geoip/docs/databases?lang=en).

## Installation

```
gem install maxmind-geoip2
```

## IP Geolocation Usage

IP geolocation is inherently imprecise. Locations are often near the center
of the population. Any location provided by a GeoIP2 database or web
service should not be used to identify a particular address or household.

## Database Reader

### Usage

To use this API, you must create a new `MaxMind::GeoIP2::Reader` object
with the path to the database file as the first argument to the
constructor. You may then call the method corresponding to the database you
are using.

If the lookup succeeds, the method call will return a model class for the
record in the database. This model in turn contains multiple container
objects for the different parts of the data such as the city in which the
IP address is located.

If the record is not found, a `MaxMind::GeoIP2::AddressNotFoundError`
exception is thrown. If the database is invalid or corrupt, a
`MaxMind::DB::InvalidDatabaseError` exception will be thrown.

See the [API documentation](https://www.rubydoc.info/gems/maxmind-geoip2)
for more details.

### City Example

```ruby
require 'maxmind/geoip2'

# This creates the Reader object which should be reused across lookups.
reader = MaxMind::GeoIP2::Reader.new(
  database: '/usr/share/GeoIP/GeoIP2-City.mmdb',
)

record = reader.city('128.101.101.101')

puts record.country.iso_code # US
puts record.country.name # United States
puts record.country.names['zh-CN'] # '美国'

puts record.most_specific_subdivision.name # Minnesota
puts record.most_specific_subdivision.iso_code # MN

puts record.city.name # Minneapolis

puts record.postal.code # 55455

puts record.location.latitude # 44.9733
puts record.location.longitude # -93.2323

puts record.traits.network # 128.101.101.101/32
```

### Country Example

```ruby
require 'maxmind/geoip2'

# This creates the Reader object which should be reused across lookups.
reader = MaxMind::GeoIP2::Reader.new(
  database: '/usr/share/GeoIP/GeoIP2-Country.mmdb',
)

record = reader.country('128.101.101.101')

puts record.country.iso_code # US
puts record.country.name # United States
puts record.country.names['zh-CN'] # '美国'
```

### Enterprise Example

```ruby
require 'maxmind/geoip2'

# This creates the Reader object which should be reused across lookups.
reader = MaxMind::GeoIP2::Reader.new(
  database: '/usr/share/GeoIP/GeoIP2-Enterprise.mmdb',
)

record = reader.enterprise('128.101.101.101')

puts record.country.confidence # 99
puts record.country.iso_code # US
puts record.country.name # United States
puts record.country.names['zh-CN'] # '美国'

puts record.most_specific_subdivision.confidence # 77
puts record.most_specific_subdivision.name # Minnesota
puts record.most_specific_subdivision.iso_code # MN

puts record.city.confidence # 60
puts record.city.name # Minneapolis

puts record.postal.code # 55455

puts record.location.accuracy_radius # 50
puts record.location.latitude # 44.9733
puts record.location.longitude # -93.2323

puts record.traits.network # 128.101.101.101/32
```

### Anonymous IP Example

```ruby
require 'maxmind/geoip2'

# This creates the Reader object which should be reused across lookups.
reader = MaxMind::GeoIP2::Reader.new(
  database: '/usr/share/GeoIP/GeoIP2-Anonymous-IP.mmdb',
)

record = reader.anonymous_ip('128.101.101.101')

puts "Anonymous" if record.is_anonymous
```

### ASN Example

```ruby
require 'maxmind/geoip2'

# This creates the Reader object which should be reused across lookups.
reader = MaxMind::GeoIP2::Reader.new(
  database: '/usr/share/GeoIP/GeoLite2-ASN.mmdb',
)

record = reader.asn('128.101.101.101')

puts record.autonomous_system_number # 1234
puts record.autonomous_system_organization # Example Ltd
```

### Connection Type Example

```ruby
require 'maxmind/geoip2'

# This creates the Reader object which should be reused across lookups.
reader = MaxMind::GeoIP2::Reader.new(
  database: '/usr/share/GeoIP/GeoIP2-Connection-Type.mmdb',
)

record = reader.connection_type('128.101.101.101')

puts record.connection_type # Cable/DSL
```

### Domain Example

```ruby
require 'maxmind/geoip2'

# This creates the Reader object which should be reused across lookups.
reader = MaxMind::GeoIP2::Reader.new(
  database: '/usr/share/GeoIP/GeoIP2-Domain.mmdb',
)

record = reader.domain('128.101.101.101')

puts record.domain # example.com
```

### ISP Example

```ruby
require 'maxmind/geoip2'

# This creates the Reader object which should be reused across lookups.
reader = MaxMind::GeoIP2::Reader.new(
  database: '/usr/share/GeoIP/GeoIP2-ISP.mmdb',
)

record = reader.isp('128.101.101.101')

puts record.autonomous_system_number # 217
puts record.autonomous_system_organization # University of Minnesota
puts record.isp # University of Minnesota
puts record.organization # University of Minnesota
```

## Web Service Client

### Usage

To use this API, you must create a new `MaxMind::GeoIP2::Client` object
with your account ID and license key. To use the GeoLite2 web service, you
may also set the `host` parameter to `geolite.info`. You may then you call
the method corresponding to a specific end point, passing it the IP address
you want to look up.

If the request succeeds, the method call will return a model class for the end
point you called. This model in turn contains multiple record classes, each of
which represents part of the data returned by the web service.

If there is an error, a structured exception is thrown.

See the [API documentation](https://www.rubydoc.info/gems/maxmind-geoip2)
for more details.

### Example

```ruby
require 'maxmind/geoip2'

# This creates a Client object that can be reused across requests.
# Replace "42" with your account ID and "license_key" with your license
# key.
client = MaxMind::GeoIP2::Client.new(
  account_id: 42,
  license_key: 'license_key',

  # To use the GeoLite2 web service instead of the GeoIP2 web service, set
  # the host parameter to "geolite.info":
  # host: 'geolite.info',

  # To use the Sandbox GeoIP2 web service instead of the production GeoIP2
  # web service, set the host parameter to "sandbox.maxmind.com":
  # host: 'sandbox.maxmind.com',
)

# Replace "city" with the method corresponding to the web service that
# you are using, e.g., "country", "insights". Please note that Insights
# is only supported by the GeoIP2 web service and not the GeoLite2 web
# service.
record = client.city('128.101.101.101')

puts record.country.iso_code # US
puts record.country.name # United States
puts record.country.names['zh-CN'] # 美国

puts record.most_specific_subdivision.name # Minnesota
puts record.most_specific_subdivision.iso_code # MN

puts record.city.name # Minneapolis

puts record.postal.code # 55455

puts record.location.latitude # 44.9733
puts record.location.longitude # -93.2323

puts record.traits.network # 128.101.101.101/32
```

## Values to use for Database or Array Keys

**We strongly discourage you from using a value from any `names` property
as a key in a database or array.**

These names may change between releases. Instead we recommend using one of
the following:

* `MaxMind::GeoIP2::Record::City` - `city.geoname_id`
* `MaxMind::GeoIP2::Record::Continent` - `continent.code` or
  `continent.geoname_id`
* `MaxMind::GeoIP2::Record::Country` and
  `MaxMind::GeoIP2::Record::RepresentedCountry` - `country.iso_code` or
  `country.geoname_id`
* `MaxMind::GeoIP2::Record::Subdivision` - `subdivision.iso_code` or
  `subdivision.geoname_id`

### What data is returned?

While many of the end points return the same basic records, the attributes
which can be populated vary between end points. In addition, while an end
point may offer a particular piece of data, MaxMind does not always have
every piece of data for any given IP address.

See the [GeoIP2 web service
documentation](https://dev.maxmind.com/geoip/docs/web-services?lang=en) for details on
what data each end point may return.

The only piece of data which is always returned is the `ip_address`
attribute in the `MaxMind::GeoIP2::Record::Traits` record.

## Integration with GeoNames

[GeoNames](https://www.geonames.org/) offers web services and downloadable
databases with data on geographical features around the world, including
populated places. They offer both free and paid premium data. Each feature
is unique identified by a `geoname_id`, which is an integer.

Many of the records returned by the GeoIP2 web services and databases
include a `geoname_id` property. This is the ID of a geographical feature
(city, region, country, etc.) in the GeoNames database.

Some of the data that MaxMind provides is also sourced from GeoNames. We
source things like place names, ISO codes, and other similar data from the
GeoNames premium data set.

## Reporting data problems

If the problem you find is that an IP address is incorrectly mapped, please
[submit your correction to MaxMind](https://www.maxmind.com/en/correction).

If you find some other sort of mistake, like an incorrect spelling, please
check the [GeoNames site](https://www.geonames.org/) first. Once you've
searched for a place and found it on the GeoNames map view, there are a
number of links you can use to correct data ("move", "edit", "alternate
names", etc.). Once the correction is part of the GeoNames data set, it
will be automatically incorporated into future MaxMind releases.

If you are a paying MaxMind customer and you're not sure where to submit a
correction, please [contact MaxMind
support](https://www.maxmind.com/en/support) for help.

## Support

Please report all issues with this code using the [GitHub issue
tracker](https://github.com/maxmind/GeoIP2-ruby/issues).

If you are having an issue with a MaxMind service that is not specific to the
client API, please see [our support page](https://www.maxmind.com/en/support).

## Requirements

This code requires Ruby version 3.0 or higher.

## Contributing

Patches and pull requests are encouraged. Please include unit tests
whenever possible.

## Versioning

This library uses [Semantic Versioning](https://semver.org/).

## Copyright and License

This software is Copyright (c) 2020-2025 by MaxMind, Inc.

This is free software, licensed under the [Apache License, Version
2.0](LICENSE-APACHE) or the [MIT License](LICENSE-MIT), at your option.
