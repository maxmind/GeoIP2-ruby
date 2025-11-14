# frozen_string_literal: true

require 'maxmind/geoip2/model/city'
require 'maxmind/geoip2/record/anonymizer'

module MaxMind
  module GeoIP2
    module Model
      # Model class for the data returned by the GeoIP2 Insights web service.
      #
      # See https://dev.maxmind.com/geoip/docs/web-services?lang=en for more
      # details.
      class Insights < City
        # Data indicating whether the IP address is part of an anonymizing
        # network.
        #
        # @return [MaxMind::GeoIP2::Record::Anonymizer]
        attr_reader :anonymizer

        # @!visibility private
        def initialize(record, locales)
          super
          @anonymizer = MaxMind::GeoIP2::Record::Anonymizer.new(
            record['anonymizer'],
          )
        end
      end
    end
  end
end
