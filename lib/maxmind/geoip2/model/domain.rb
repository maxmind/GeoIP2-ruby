# frozen_string_literal: true

require 'maxmind/geoip2/model/abstract'

module MaxMind
  module GeoIP2
    module Model
      # Model class for the GeoIP2 Domain database.
      class Domain < Abstract
        # The second level domain associated with the IP address. This will be
        # something like "example.com" or "example.co.uk", not "foo.example.com".
        #
        # @return [String, nil]
        def domain
          get('domain')
        end

        # The IP address that the data in the model is for.
        #
        # @return [String]
        def ip_address
          get('ip_address')
        end

        # The network in CIDR notation associated with the record. In particular,
        # this is the largest network where all of the fields besides ip_address
        # have the same value.
        #
        # @return [String]
        def network
          get('network')
        end
      end
    end
  end
end
