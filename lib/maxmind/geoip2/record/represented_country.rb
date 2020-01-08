# frozen_string_literal: true

require 'maxmind/geoip2/record/country'

module MaxMind::GeoIP2::Record
  # Contains data for the represented country associated with an IP address.
  #
  # This class contains the country-level data associated with an IP address
  # for the IP's represented country. The represented country is the country
  # represented by something like a military base.
  #
  # See Country for inherited methods.
  class RepresentedCountry < Country
    # A string indicating the type of entity that is representing the country.
    # Currently we only return +military+ but this could expand to include
    # other types in the future. String but may be nil.
    def type
      get('type')
    end
  end
end
