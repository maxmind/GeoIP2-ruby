# frozen_string_literal: true

require 'maxmind/geoip2/model/abstract'

module MaxMind
  module GeoIP2
    module Model
      # Model class for the GeoIP2 ISP database.
      class ISP < Abstract
        # The autonomous system number associated with the IP address.
        #
        # @return [Integer, nil]
        def autonomous_system_number
          get('autonomous_system_number')
        end

        # The organization associated with the registered autonomous system number
        # for the IP address.
        #
        # @return [String, nil]
        def autonomous_system_organization
          get('autonomous_system_organization')
        end

        # The IP address that the data in the model is for.
        #
        # @return [String]
        def ip_address
          get('ip_address')
        end

        # The name of the ISP associated with the IP address.
        #
        # @return [String, nil]
        def isp
          get('isp')
        end

        # The {https://en.wikipedia.org/wiki/Mobile_country_code mobile country
        # code (MCC)} associated with the IP address and ISP.
        #
        # @return [String, nil]
        def mobile_country_code
          get('mobile_country_code')
        end

        # The {https://en.wikipedia.org/wiki/Mobile_country_code mobile network
        # code (MNC)} associated with the IP address and ISP.
        #
        # @return [String, nil]
        def mobile_network_code
          get('mobile_network_code')
        end

        # The network in CIDR notation associated with the record. In particular,
        # this is the largest network where all of the fields besides ip_address
        # have the same value.
        #
        # @return [String]
        def network
          get('network')
        end

        # The name of the organization associated with the IP address.
        #
        # @return [String, nil]
        def organization
          get('organization')
        end
      end
    end
  end
end
