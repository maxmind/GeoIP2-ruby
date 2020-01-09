# frozen_string_literal: true

require 'maxmind/geoip2/record/abstract'

module MaxMind::GeoIP2::Record
  # Location data common to different location types.
  class Place < Abstract
    def initialize(record, locales) # :nodoc:
      super(record)
      @locales = locales
    end

    # A string containing the first available localized name in order of
    # preference.
    def name
      n = names
      return nil if n.nil?

      @locales.each do |locale|
        return n[locale] if n.key?(locale)
      end

      nil
    end
  end
end
