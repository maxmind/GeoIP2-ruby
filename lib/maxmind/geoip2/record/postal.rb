# frozen_string_literal: true

require 'maxmind/geoip2/record/abstract'

module MaxMind
  module GeoIP2
    module Record
      # Contains data for the postal record associated with an IP address.
      #
      # This record is returned by all location services and databases besides
      # Country.
      class Postal < Abstract
        # The postal code of the location. Postal codes are not available for all
        # countries. In some countries, this will only contain part of the postal
        # code. This attribute is returned by all location databases and services
        # besides Country.
        #
        # @return [String, nil]
        def code
          get('code')
        end

        # A value from 0-100 indicating MaxMind's confidence that the postal code
        # is correct. This attribute is only available from the Insights service
        # and the GeoIP2 Enterprise database.
        #
        # @return [Integer, nil]
        def confidence
          get('confidence')
        end
      end
    end
  end
end
