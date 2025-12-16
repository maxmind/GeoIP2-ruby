# frozen_string_literal: true

require 'ipaddr'
require 'maxmind/geoip2/record/abstract'

module MaxMind
  module GeoIP2
    module Record
      # Contains data for the traits record associated with an IP address.
      #
      # This record is returned by all location services and databases.
      class Traits < Abstract
        # @!visibility private
        def initialize(record)
          super
          if record && !record.key?('network') && record.key?('ip_address') &&
             record.key?('prefix_length')
            ip = IPAddr.new(record['ip_address']).mask(record['prefix_length'])
            record['network'] = format('%s/%d', ip.to_s, ip.prefix)
          end
        end

        # The autonomous system number associated with the IP address. See
        # Wikipedia[https://en.wikipedia.org/wiki/Autonomous_system_(Internet)].
        # This attribute is only available from the City Plus and Insights web
        # services and the Enterprise database.
        #
        # @return [Integer, nil]
        def autonomous_system_number
          get('autonomous_system_number')
        end

        # The organization associated with the registered autonomous system number
        # for the IP address. See
        # Wikipedia[https://en.wikipedia.org/wiki/Autonomous_system_(Internet)].
        # This attribute is only available from the City Plus and Insights web
        # services and the Enterprise database.
        #
        # @return [String, nil]
        def autonomous_system_organization
          get('autonomous_system_organization')
        end

        # The connection type may take the following  values: "Dialup",
        # "Cable/DSL", "Corporate", "Cellular", and "Satellite". Additional
        # values may be added in the future. This attribute is only available
        # from the City Plus and Insights web services and the Enterprise
        # database.
        #
        # @return [String, nil]
        def connection_type
          get('connection_type')
        end

        # The second level domain associated with the IP address. This will be
        # something like "example.com" or "example.co.uk", not "foo.example.com".
        # This attribute is only available from the City Plus and Insights web
        # services and the Enterprise database.
        #
        # @return [String, nil]
        def domain
          get('domain')
        end

        # The IP address that the data in the model is for. If you performed a "me"
        # lookup against the web service, this will be the externally routable IP
        # address for the system the code is running on. If the system is behind a
        # NAT, this may differ from the IP address locally assigned to it. This
        # attribute is returned by all end points.
        #
        # @return [String, nil]
        def ip_address
          get('ip_address')
        end

        # This is true if the IP address belongs to any sort of anonymous network.
        # This property is only available from Insights.
        #
        # This method is deprecated as of version 1.4.0. Use the anonymizer object
        # from the Insights response instead.
        #
        # @return [Boolean]
        # @deprecated since 1.4.0
        def anonymous?
          get('is_anonymous')
        end

        # This is true if the IP address is registered to an anonymous VPN
        # provider. If a VPN provider does not register subnets under names
        # associated with them, we will likely only flag their IP ranges using the
        # hosting_provider? property. This property is only available from Insights.
        #
        # This method is deprecated as of version 1.4.0. Use the anonymizer object
        # from the Insights response instead.
        #
        # @return [Boolean]
        # @deprecated since 1.4.0
        def anonymous_vpn?
          get('is_anonymous_vpn')
        end

        # This is true if the IP address belongs to an
        # {https://en.wikipedia.org/wiki/Anycast anycast network}.
        #
        # This property is only available from the Country, City Plus, and
        # Insights web services and the GeoIP2 Country, City, and Enterprise
        # databases.
        #
        # @return [Boolean]
        def anycast?
          get('is_anycast')
        end

        # This is true if the IP address belongs to a hosting or VPN provider (see
        # description of the anonymous_vpn? property). This property is only
        # available from Insights.
        #
        # This method is deprecated as of version 1.4.0. Use the anonymizer object
        # from the Insights response instead.
        #
        # @return [Boolean]
        # @deprecated since 1.4.0
        def hosting_provider?
          get('is_hosting_provider')
        end

        # This attribute is true if MaxMind believes this IP address to be a
        # legitimate proxy, such as an internal VPN used by a corporation. This
        # attribute is only available in the Enterprise database.
        #
        # @return [Boolean]
        def legitimate_proxy?
          get('is_legitimate_proxy')
        end

        # The {https://en.wikipedia.org/wiki/Mobile_country_code mobile country
        # code (MCC)} associated with the IP address and ISP.
        #
        # This attribute is only available from the City Plus and Insights web
        # services and the Enterprise database.
        #
        # @return [String, nil]
        def mobile_country_code
          get('mobile_country_code')
        end

        # The {https://en.wikipedia.org/wiki/Mobile_country_code mobile network
        # code (MNC)} associated with the IP address and ISP.
        #
        # This attribute is only available from the City Plus and Insights web
        # services and the Enterprise database.
        #
        # @return [String, nil]
        def mobile_network_code
          get('mobile_network_code')
        end

        # This is true if the IP address belongs to a public proxy. This property
        # is only available from Insights.
        #
        # This method is deprecated as of version 1.4.0. Use the anonymizer object
        # from the Insights response instead.
        #
        # @return [Boolean]
        # @deprecated since 1.4.0
        def public_proxy?
          get('is_public_proxy')
        end

        # This is true if the IP address is on a suspected anonymizing network
        # and belongs to a residential ISP. This property is only available
        # from Insights.
        #
        # This method is deprecated as of version 1.4.0. Use the anonymizer object
        # from the Insights response instead.
        #
        # @return [Boolean]
        # @deprecated since 1.4.0
        def residential_proxy?
          get('is_residential_proxy')
        end

        # This is true if the IP address is a Tor exit node. This property is only
        # available from Insights.
        #
        # This method is deprecated as of version 1.4.0. Use the anonymizer object
        # from the Insights response instead.
        #
        # @return [Boolean]
        # @deprecated since 1.4.0
        def tor_exit_node?
          get('is_tor_exit_node')
        end

        # The name of the ISP associated with the IP address. This attribute is
        # only available from the City Plus and Insights web services and the
        # Enterprise database.
        #
        # @return [String, nil]
        def isp
          get('isp')
        end

        # The network in CIDR notation associated with the record. In particular,
        # this is the largest network where all of the fields besides ip_address
        # have the same value.
        #
        # @return [String, nil]
        def network
          get('network')
        end

        # The name of the organization associated with the IP address. This
        # attribute is only available from the City Plus and Insights web services
        # and the Enterprise database.
        #
        # @return [String, nil]
        def organization
          get('organization')
        end

        # An indicator of how static or dynamic an IP address is. This property is
        # only available from Insights.
        #
        # @return [Float, nil]
        def static_ip_score
          get('static_ip_score')
        end

        # The estimated number of users sharing the IP/network during the past 24
        # hours. For IPv4, the count is for the individual IP. For IPv6, the count
        # is for the /64 network. This property is only available from Insights.
        #
        # @return [Integer, nil]
        def user_count
          get('user_count')
        end

        # This field contains the risk associated with the IP address. The value
        # ranges from 0.01 to 99. A higher score indicates a higher risk.
        # Please note that the IP risk score provided in GeoIP products and
        # services is more static than the IP risk score provided in minFraud
        # and is not responsive to traffic on your network. If you need realtime
        # IP risk scoring based on behavioral signals on your own network, please
        # use minFraud.
        #
        # We do not provide an IP risk snapshot for low-risk networks. If this
        # field is not populated, we either do not have signals for the network
        # or the signals we have show that the network is low-risk. If you would
        # like to get signals for low-risk networks, please use the minFraud web
        # services.
        #
        # This property is only available from Insights.
        #
        # @return [Float, nil]
        def ip_risk_snapshot
          get('ip_risk_snapshot')
        end

        # The user type associated with the IP address. This can be one of the
        # following values:
        #
        # * business
        # * cafe
        # * cellular
        # * college
        # * consumer_privacy_network
        # * content_delivery_network
        # * dialup
        # * government
        # * hosting
        # * library
        # * military
        # * residential
        # * router
        # * school
        # * search_engine_spider
        # * traveler
        #
        # This attribute is only available from the Insights web service and the
        # Enterprise database.
        #
        # @return [String, nil]
        def user_type
          get('user_type')
        end
      end
    end
  end
end
