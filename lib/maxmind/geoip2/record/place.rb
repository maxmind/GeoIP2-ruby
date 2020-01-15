# frozen_string_literal: true

require 'maxmind/geoip2/record/abstract'

module MaxMind::GeoIP2::Record
  # Location data common to different location types.
  class Place < Abstract
    # @!visibility private
    def initialize(record, locales)
      super(record)
      @locales = locales
    end

    # The first available localized name in order of preference.
    #
    # @return [String, nil]
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
