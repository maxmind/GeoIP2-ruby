# frozen_string_literal: true

require 'maxmind/geoip2/record/place'

module MaxMind::GeoIP2::Record
  # Contains data for the country record associated with an IP address.
  #
  # This record is returned by all location services and databases.
  #
  # See {MaxMind::GeoIP2::Record::Place} for inherited methods.
  class Country < Place
    # A value from 0-100 indicating MaxMind's confidence that the country is
    # correct. This attribute is only available from the Insights service and
    # the GeoIP2 Enterprise database.
    #
    # @return [Integer, nil]
    def confidence
      get('confidence')
    end

    # The GeoName ID for the country. This attribute is returned by all
    # location services and databases.
    #
    # @return [Integer, nil]
    def geoname_id
      get('geoname_id')
    end

    # This is true if the country is a member state of the European Union. This
    # attribute is returned by all location services and databases.
    #
    # @return [Boolean]
    def in_european_union?
      get('is_in_european_union')
    end

    # The two-character ISO 3166-1 alpha code for the country. See
    # https://en.wikipedia.org/wiki/ISO_3166-1. This attribute is returned by
    # all location services and databases.
    #
    # @return [String, nil]
    def iso_code
      get('iso_code')
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
