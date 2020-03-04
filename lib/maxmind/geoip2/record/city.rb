# frozen_string_literal: true

require 'maxmind/geoip2/record/place'

module MaxMind
  module GeoIP2
    module Record
      # City-level data associated with an IP address.
      #
      # This record is returned by all location services and databases besides
      # Country.
      #
      # See {MaxMind::GeoIP2::Record::Place} for inherited methods.
      class City < Place
        # A value from 0-100 indicating MaxMind's confidence that the city is
        # correct. This attribute is only available from the Insights service and
        # the GeoIP2 Enterprise database.
        #
        # @return [Integer, nil]
        def confidence
          get('confidence')
        end

        # The GeoName ID for the city. This attribute is returned by all location
        # services and databases.
        #
        # @return [Integer, nil]
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
  end
end
