# frozen_string_literal: true

require 'maxmind/geoip2/record/abstract'

module MaxMind::GeoIP2::Record
  # Contains data for the location record associated with an IP address.
  #
  # This record is returned by all location services and databases besides
  # Country.
  class Location < Abstract
    # The approximate accuracy radius in kilometers around the latitude and
    # longitude for the IP address. This is the radius where we have a 67%
    # confidence that the device using the IP address resides within the circle
    # centered at the latitude and longitude with the provided radius. Integer
    # but may be nil.
    def accuracy_radius
      get('accuracy_radius')
    end

    # The average income in US dollars associated with the requested IP
    # address. This attribute is only available from the Insights service.
    # Integer but may be nil.
    def average_income
      get('average_income')
    end

    # The approximate latitude of the location associated with the IP address.
    # This value is not precise and should not be used to identify a particular
    # address or household. Float but may be nil.
    def latitude
      get('latitude')
    end

    # The approximate longitude of the location associated with the IP address.
    # This value is not precise and should not be used to identify a particular
    # address or household. Float but may be nil.
    def longitude
      get('longitude')
    end

    # The metro code of the location if the location is in the US. MaxMind
    # returns the same metro codes as the Google AdWords API. See
    # https://developers.google.com/adwords/api/docs/appendix/cities-DMAregions.
    # Integer but may be nil.
    def metro_code
      get('metro_code')
    end

    # The estimated population per square kilometer associated with the IP
    # address. This attribute is only available from the Insights service.
    # Integer but may be nil.
    def population_density
      get('population_density')
    end

    # The time zone associated with location, as specified by the IANA Time
    # Zone Database, e.g., "America/New_York". See
    # https://www.iana.org/time-zones. String but may be nil.
    def time_zone
      get('time_zone')
    end
  end
end
