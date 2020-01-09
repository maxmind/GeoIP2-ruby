# frozen_string_literal: true

require 'maxmind/geoip2/record/place'

module MaxMind::GeoIP2::Record
  # Contains data for the subdivisions associated with an IP address.
  #
  # This record is returned by all location databases and services besides
  # Country.
  #
  # See Place for inherited methods.
  class Subdivision < Place
    # This is a value from 0-100 indicating MaxMind's confidence that the
    # subdivision is correct. This attribute is only available from the
    # Insights service and the GeoIP2 Enterprise database. Integer but may be
    # nil.
    def confidence
      get('confidence')
    end

    # This is a GeoName ID for the subdivision. This attribute is returned by
    # all location databases and services besides Country. Integer but may be
    # nil.
    def geoname_id
      get('geoname_id')
    end

    # This is a string up to three characters long contain the subdivision
    # portion of the ISO 3166-2 code. See
    # https://en.wikipedia.org/wiki/ISO_3166-2. This attribute is returned by
    # all location databases and services except Country. String but may be
    # nil.
    def iso_code
      get('iso_code')
    end

    # A Hash where the keys are locale codes (Strings) and the values are names
    # (Strings). This attribute is returned by all location services and
    # databases besides country. Hash but may be nil.
    def names
      get('names')
    end
  end
end
