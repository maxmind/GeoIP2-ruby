# frozen_string_literal: true

require 'maxmind/geoip2/record/place'

module MaxMind::GeoIP2::Record
  # City-level data associated with an IP address.
  #
  # This record is returned by all location services and databases besides
  # Country.
  #
  # See Place for inherited methods.
  class City < Place
    # A value from 0-100 indicating MaxMind's confidence that the city is
    # correct. This attribute is only available from the Insights service and
    # the GeoIP2 Enterprise database. Integer but may be nil.
    def confidence
      get('confidence')
    end

    # The GeoName ID for the city. This attribute is returned by all location
    # services and databases. Integer but may be nil.
    def geoname_id
      get('geoname_id')
    end

    # Returns a Hash where the keys are locale codes (Strings) and the values
    # are names (Strings). This attribute is returned by all location services
    # and databases. Hash but may be nil.
    def names
      get('names')
    end
  end
end
