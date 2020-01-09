# frozen_string_literal: true

module MaxMind::GeoIP2
  # An AddressNotFoundError means the IP address was not found in the database.
  class AddressNotFoundError < RuntimeError
  end
end
