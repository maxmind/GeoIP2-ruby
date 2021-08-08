# frozen_string_literal: true

module MaxMind
  module GeoIP2
    # Module's base error class
    class Error < StandardError
    end
    
    # Base error class for all errors that originate from the IP address
    # itself and will not change when retried.
    class AddressError < Error
    end
    
    # An AddressNotFoundError means the IP address was not found in the
    # database or the web service said the IP address was not found.
    class AddressNotFoundError < AddressError
    end

    # An HTTPError means there was an unexpected HTTP status or response.
    class HTTPError < Error
    end

    # An AddressInvalidError means the IP address was invalid.
    class AddressInvalidError < AddressError
    end

    # An AddressReservedError means the IP address is reserved.
    class AddressReservedError < AddressError
    end

    # An AuthenticationError means there was a problem authenticating to the
    # web service.
    class AuthenticationError < Error
    end

    # An InsufficientFundsError means the account is out of credits.
    class InsufficientFundsError < Error
    end

    # A PermissionRequiredError means the account does not have permission to
    # use the requested service.
    class PermissionRequiredError < Error
    end

    # An InvalidRequestError means the web service returned an error and there
    # is no more specific error class.
    class InvalidRequestError < Error
    end
  end
end
