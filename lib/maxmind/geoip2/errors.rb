# frozen_string_literal: true

# Disable this because I wish to ensure the MaxMind constant is defined,
# which apparently must be done without using the compact syntax.
#
# rubocop:disable Style/ClassAndModuleChildren

# A module for namespacing purposes.
module MaxMind
  module GeoIP2
    # An AddressNotFoundError means the IP address was not found in the
    # database or the web service said the IP address was not found.
    class AddressNotFoundError < RuntimeError
    end

    # An HTTPError means there was an unexpected HTTP status or response.
    class HTTPError < RuntimeError
    end

    # An AddressInvalidError means the IP address was invalid.
    class AddressInvalidError < RuntimeError
    end

    # An AddressReservedError means the IP address is reserved.
    class AddressReservedError < RuntimeError
    end

    # An AuthenticationError means there was a problem authenticating to the
    # web service.
    class AuthenticationError < RuntimeError
    end

    # An OutOfQueriesError means the account is out of credits.
    class OutOfQueriesError < RuntimeError
    end

    # A PermissionRequiredError means the account does not have permission to
    # use the requested service.
    class PermissionRequiredError < RuntimeError
    end

    # An InvalidRequestError means the web service returned an error and there
    # is no more specific error class.
    class InvalidRequestError < RuntimeError
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
