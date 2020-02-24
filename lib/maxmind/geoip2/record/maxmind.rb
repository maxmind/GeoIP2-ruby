# frozen_string_literal: true

require 'maxmind/geoip2/record/abstract'

module MaxMind::GeoIP2::Record
  # Contains data about your account.
  #
  # This record is returned by all location services.
  class MaxMind < Abstract
    # The number of remaining queries you have for the service you are calling.
    #
    # @return [Integer, nil]
    def queries_remaining
      get('queries_remaining')
    end
  end
end
