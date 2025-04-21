# frozen_string_literal: true

require 'date'
require 'maxmind/geoip2/model/anonymous_ip'

module MaxMind
  module GeoIP2
    module Model
      # Model class for the Anonymous Plus database.
      class AnonymousPlus < AnonymousIP
        # A score ranging from 1 to 99 that is our percent confidence that the
        # network is currently part of an actively used VPN service.
        #
        # @return [Integer, nil]
        def anonymizer_confidence
          get('anonymizer_confidence')
        end

        # The last day that the network was sighted in our analysis of
        # anonymized networks. This value is parsed lazily.
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
        # associated with the network.
        #
        # @return [String, nil]
        def provider_name
          get('provider_name')
        end
      end
    end
  end
end
