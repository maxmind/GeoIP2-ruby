# frozen_string_literal: true

require 'maxmind/geoip2/record/place'

module MaxMind::GeoIP2::Record
  # Contains data for the continent record associated with an IP address.
  #
  # This record is returned by all location services and databases.
  #
  # See Place for inherited methods.
  class Continent < Place
    # A two character continent code like "NA" (North America) or "OC"
    # (Oceania). This attribute is returned by all location services and
    # databases. String but may be nil.
    def code
      get('code')
    end

    # The GeoName ID for the continent. This attribute is returned by all
    # location services and databases. String but may be nil.
    def geoname_id
      get('geoname_id')
    end

    # A Hash where the keys are locale codes (Strings) and the values are names
    # (Strings). This attribute is returned by all location services and
    # databases. Hash but may be nil.
    def names
      get('names')
    end
  end
end
