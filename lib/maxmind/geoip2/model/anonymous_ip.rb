# frozen_string_literal: true

require 'maxmind/geoip2/model/abstract'

module MaxMind::GeoIP2::Model
  # Model class for the Anonymous IP database.
  class AnonymousIP < Abstract
    # This is true if the IP address belongs to any sort of anonymous network.
    #
    # @return [Boolean]
    def anonymous?
      get('is_anonymous')
    end

    # This is true if the IP address is registered to an anonymous VPN
    # provider. If a VPN provider does not register subnets under names
    # associated with them, we will likely only flag their IP ranges using the
    # is_hosting_provider attribute.
    #
    # @return [Boolean]
    def anonymous_vpn?
      get('is_anonymous_vpn')
    end

    # This is true if the IP address belongs to a hosting or VPN provider (see
    # description of the is_anonymous_vpn attribute).
    #
    # @return [Boolean]
    def hosting_provider?
      get('is_hosting_provider')
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

    # This is true if the IP address belongs to a public proxy.
    #
    # @return [Boolean]
    def public_proxy?
      get('is_public_proxy')
    end

    # This is true if the IP address is a Tor exit node.
    #
    # @return [Boolean]
    def tor_exit_node?
      get('is_tor_exit_node')
    end
  end
end
