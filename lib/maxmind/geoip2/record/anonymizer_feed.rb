# frozen_string_literal: true

require 'date'
require 'maxmind/geoip2/record/abstract'

module MaxMind
  module GeoIP2
    module Record
      # Contains data for one type of anonymizer detection, currently
      # residential proxies. Additional feeds may be added in the future.
      #
      # This record is returned by the anonymizer object of the Insights web
      # service.
      class AnonymizerFeed < Abstract
        # A score ranging from 1 to 99 that represents our percent confidence
        # that the network is currently part of this anonymizer feed. This
        # property is only available from Insights.
        #
        # @return [Integer, nil]
        def confidence
          get('confidence')
        end

        # The last day that the network was sighted in our analysis of this
        # anonymizer feed. This value is parsed lazily. This property is only
        # available from Insights.
        #
        # @return [Date, nil] A Date object representing the last seen date,
        #   or nil if the date is not available.
        def network_last_seen
          return @network_last_seen if defined?(@network_last_seen)

          date_string = get('network_last_seen')

          if !date_string
            @network_last_seen = nil
            return nil
          end

          @network_last_seen = Date.parse(date_string)
        end

        # The name of the provider associated with the network in this
        # anonymizer feed. This property is only available from Insights.
        #
        # @return [String, nil]
        def provider_name
          get('provider_name')
        end
      end
    end
  end
end
