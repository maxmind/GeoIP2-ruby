# frozen_string_literal: true

require 'date'
require 'maxmind/geoip2/record/abstract'

module MaxMind
  module GeoIP2
    module Record
      # Contains data indicating whether an IP address is part of an
      # anonymizing network.
      #
      # This record is returned by the Insights web service.
      class Anonymizer < Abstract
        # A score ranging from 1 to 99 that represents our percent confidence
        # that the network is currently part of an actively used VPN service.
        # This property is only available from Insights.
        #
        # @return [Integer, nil]
        def confidence
          get('confidence')
        end

        # This is true if the IP address belongs to any sort of anonymous
        # network. This property is only available from Insights.
        #
        # @return [Boolean]
        def anonymous?
          get('is_anonymous')
        end

        # This is true if the IP address is registered to an anonymous VPN
        # provider. If a VPN provider does not register subnets under names
        # associated with them, we will likely only flag their IP ranges using
        # the hosting_provider? property. This property is only available from
        # Insights.
        #
        # @return [Boolean]
        def anonymous_vpn?
          get('is_anonymous_vpn')
        end

        # This is true if the IP address belongs to a hosting or VPN provider
        # (see description of the anonymous_vpn? property). This property is
        # only available from Insights.
        #
        # @return [Boolean]
        def hosting_provider?
          get('is_hosting_provider')
        end

        # This is true if the IP address belongs to a public proxy. This
        # property is only available from Insights.
        #
        # @return [Boolean]
        def public_proxy?
          get('is_public_proxy')
        end

        # This is true if the IP address is on a suspected anonymizing network
        # and belongs to a residential ISP. This property is only available from
        # Insights.
        #
        # @return [Boolean]
        def residential_proxy?
          get('is_residential_proxy')
        end

        # This is true if the IP address is a Tor exit node. This property is
        # only available from Insights.
        #
        # @return [Boolean]
        def tor_exit_node?
          get('is_tor_exit_node')
        end

        # The last day that the network was sighted in our analysis of
        # anonymized networks. This value is parsed lazily. This property is
        # only available from Insights.
        #
        # @return [Date, nil] A Date object representing the last seen date,
        #   or nil if the date is not available.
        def network_last_seen
          return @network_last_seen if defined?(@network_last_seen)

          date_string = get('network_last_seen')

          if !date_string
            return nil
          end

          @network_last_seen = Date.parse(date_string)
        end

        # The name of the VPN provider (e.g., NordVPN, SurfShark, etc.)
        # associated with the network. This property is only available from
        # Insights.
        #
        # @return [String, nil]
        def provider_name
          get('provider_name')
        end
      end
    end
  end
end
