# frozen_string_literal: true

require 'maxmind/geoip2/record/place'

module MaxMind::GeoIP2::Record
  # Contains data for the continent record associated with an IP address.
  #
  # This record is returned by all location services and databases.
  #
  # See {MaxMind::GeoIP2::Record::Place} for inherited methods.
  class Continent < Place
    # A two character continent code like "NA" (North America) or "OC"
    # (Oceania). This attribute is returned by all location services and
    # databases.
    #
    # @return [String, nil]
    def code
      get('code')
    end

    # The GeoName ID for the continent. This attribute is returned by all
    # location services and databases.
    #
    # @return [String, nil]
    def geoname_id
      get('geoname_id')
    end

    # A Hash where the keys are locale codes and the values are names. This
    # attribute is returned by all location services and databases.
    #
    # @return [Hash<String, String>, nil]
    def names
      get('names')
    end
  end
end
