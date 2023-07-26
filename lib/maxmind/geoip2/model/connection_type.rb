# frozen_string_literal: true

require 'maxmind/geoip2/model/abstract'

module MaxMind
  module GeoIP2
    module Model
      # Model class for the GeoIP2 Connection Type database.
      class ConnectionType < Abstract
        # The connection type may take the following values: "Dialup",
        # "Cable/DSL", "Corporate", "Cellular", and "Satellite". Additional
        # values may be added in the future.
        #
        # @return [String, nil]
        def connection_type
          get('connection_type')
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
