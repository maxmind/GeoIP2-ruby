# frozen_string_literal: true

require 'maxmind/geoip2/model/city'

module MaxMind::GeoIP2::Model
  # Model class for the data returned by the GeoIP2 Precision Insights web
  # service.
  #
  # The only difference between the City and Insights model classes is which
  # fields in each record may be populated. See
  # https://dev.maxmind.com/geoip/geoip2/web-services for more details.
  class Insights < City
  end
end
