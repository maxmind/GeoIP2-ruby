# frozen_string_literal: true

require 'maxmind/geoip2/model/city'

module MaxMind
  module GeoIP2
    module Model
      # Model class for the data returned by the GeoIP2 Insights web service.
      #
      # See https://dev.maxmind.com/geoip/docs/web-services?lang=en for more
      # details.
      class Insights < City
      end
    end
  end
end
