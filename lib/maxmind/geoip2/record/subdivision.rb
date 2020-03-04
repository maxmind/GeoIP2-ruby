# frozen_string_literal: true

require 'maxmind/geoip2/record/place'

module MaxMind
  module GeoIP2
    module Record
      # Contains data for the subdivisions associated with an IP address.
      #
      # This record is returned by all location databases and services besides
      # Country.
      #
      # See {MaxMind::GeoIP2::Record::Place} for inherited methods.
      class Subdivision < Place
        # This is a value from 0-100 indicating MaxMind's confidence that the
        # subdivision is correct. This attribute is only available from the
        # Insights service and the GeoIP2 Enterprise database.
        #
        # @return [Integer, nil]
        def confidence
          get('confidence')
        end

        # This is a GeoName ID for the subdivision. This attribute is returned by
        # all location databases and services besides Country.
        #
        # @return [Integer, nil]
        def geoname_id
          get('geoname_id')
        end

        # This is a string up to three characters long contain the subdivision
        # portion of the ISO 3166-2 code. See
        # https://en.wikipedia.org/wiki/ISO_3166-2. This attribute is returned by
        # all location databases and services except Country.
        #
        # @return [String, nil]
        def iso_code
          get('iso_code')
        end

        # A Hash where the keys are locale codes and the values are names. This attribute is returned by all location services and
        # databases besides country.
        #
        # @return [Hash<String, String>, nil]
        def names
          get('names')
        end
      end
    end
  end
end
