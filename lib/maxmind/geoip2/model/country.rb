# frozen_string_literal: true

require 'maxmind/geoip2/record/continent'
require 'maxmind/geoip2/record/country'
require 'maxmind/geoip2/record/represented_country'
require 'maxmind/geoip2/record/traits'

module MaxMind::GeoIP2::Model
  # Model class for the data returned by the GeoIP2 Country web service and
  # database. It is also used for GeoLite2 Country lookups.
  class Country
    # Continent data for the IP address.
    #
    # @return [MaxMind::GeoIP2::Record::Continent]
    attr_reader :continent

    # Country data for the IP address. This object represents the country where
    # MaxMind believes the end user is located.
    #
    # @return [MaxMind::GeoIP2::Record::Country]
    attr_reader :country

    # Registered country data for the IP address. This record represents the
    # country where the ISP has registered a given IP block and may differ from
    # the user's country.
    #
    # @return [MaxMind::GeoIP2::Record::Country]
    attr_reader :registered_country

    # Represented country data for the IP address. The represented country is
    # used for things like military bases. It is only present when the
    # represented country differs from the country.
    #
    # @return [MaxMind::GeoIP2::Record::RepresentedCountry]
    attr_reader :represented_country

    # Data for the traits of the IP address.
    #
    # @return [MaxMind::GeoIP2::Record::Traits]
    attr_reader :traits

    # @!visibility private
    def initialize(record, locales)
      @continent = MaxMind::GeoIP2::Record::Continent.new(
        record['continent'],
        locales,
      )
      @country = MaxMind::GeoIP2::Record::Country.new(
        record['country'],
        locales,
      )
      @registered_country = MaxMind::GeoIP2::Record::Country.new(
        record['registered_country'],
        locales,
      )
      @represented_country = MaxMind::GeoIP2::Record::RepresentedCountry.new(
        record['represented_country'],
        locales,
      )
      @traits = MaxMind::GeoIP2::Record::Traits.new(record['traits'])
    end
  end
end
