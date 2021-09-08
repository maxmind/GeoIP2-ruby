# frozen_string_literal: true

require 'maxmind/geoip2/model/city'

module MaxMind
  module GeoIP2
    module Model
      # Model class for the data returned by GeoIP2 Enterprise database lookups.
      #
      # The only difference between the City and Insights model classes is which
      # fields in each record may be populated. See
      # https://dev.maxmind.com/geoip/docs/web-services?lang=en for more details.
      #
      # See {MaxMind::GeoIP2::Model::City} for inherited methods.
      class Enterprise < City
      end
    end
  end
end
