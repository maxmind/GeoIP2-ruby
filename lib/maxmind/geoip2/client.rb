# frozen_string_literal: true

require 'connection_pool'
require 'http'
require 'json'
require 'maxmind/geoip2/errors'
require 'maxmind/geoip2/model/city'
require 'maxmind/geoip2/model/country'
require 'maxmind/geoip2/model/insights'

module MaxMind
  module GeoIP2
    # This class provides a client API for all the
    # {https://dev.maxmind.com/geoip/geoip2/web-services/ GeoIP2 Precision web
    # services}. The services are Country, City, and Insights. Each service
    # returns a different set of data about an IP address, with Country returning
    # the least data and Insights the most.
    #
    # Each web service is represented by a different model class, and these model
    # classes in turn contain multiple record classes. The record classes have
    # attributes which contain data about the IP address.
    #
    # If the web service does not return a particular piece of data for an IP
    # address, the associated attribute is not populated.
    #
    # The web service may not return any information for an entire record, in
    # which case all of the attributes for that record class will be empty.
    #
    # == Usage
    #
    # The basic API for this class is the same for all of the web service end
    # points. First you create a web service client object with your MaxMind
    # account ID and license key, then you call the method corresponding to a
    # specific end point, passing it the IP address you want to look up.
    #
    # If the request succeeds, the method call will return a model class for the
    # service you called. This model in turn contains multiple record classes,
    # each of which represents part of the data returned by the web service.
    #
    # If the request fails, the client class throws an exception.
    #
    # == Example
    #
    #   require 'maxmind/geoip2'
    #
    #   client = MaxMind::GeoIP2::Client.new(
    #     account_id: 42,
    #     license_key: 'abcdef123456',
    #   )
    #
    #   # Replace 'city' with the method corresponding to the web service you
    #   # are using, e.g., 'country', 'insights'.
    #   record = client.city('128.101.101.101')
    #
    #   puts record.country.iso_code
    class Client
      # rubocop:disable Metrics/ParameterLists

      # Create a Client that may be used to query a GeoIP2 Precision web service.
      #
      # Once created, the Client is safe to use for lookups from multiple
      # threads.
      #
      # @param account_id [Integer] your MaxMind account ID.
      #
      # @param license_key [String] your MaxMind license key.
      #
      # @param locales [Array<String>] a list of locale codes to use in the name
      #   property from most preferred to least preferred.
      #
      # @param host [String] the host to use when querying the web service.
      #
      # @param timeout [Integer] the number of seconds to wait for a request
      #   before timing out. If 0, no timeout is set.
      #
      # @param proxy_address [String] proxy address to use, if any.
      #
      # @param proxy_port [Integer] proxy port to use, if any.
      #
      # @param proxy_username [String] proxy username to use, if any.
      #
      # @param proxy_password [String] proxy password to use, if any.
      #
      # @param pool_size [Integer] HTTP connection pool size
      def initialize(
        account_id:,
        license_key:,
        locales: ['en'],
        host: 'geoip.maxmind.com',
        timeout: 0,
        proxy_address: '',
        proxy_port: 0,
        proxy_username: '',
        proxy_password: '',
        pool_size: 5
      )
        @account_id = account_id
        @license_key = license_key
        @locales = locales
        @host = host
        @timeout = timeout
        @proxy_address = proxy_address
        @proxy_port = proxy_port
        @proxy_username = proxy_username
        @proxy_password = proxy_password
        @pool_size = pool_size

        @connection_pool = ConnectionPool.new(size: @pool_size) do
          make_http_client.persistent("https://#{@host}")
        end
      end
      # rubocop:enable Metrics/ParameterLists

      # This method calls the GeoIP2 Precision City web service.
      #
      # @param ip_address [String] IPv4 or IPv6 address as a string. If no
      #   address is provided, the address that the web service is called from is
      #   used.
      #
      # @raise [HTTP::Error] if there was an error performing the HTTP request,
      #   such as an error connecting.
      #
      # @raise [JSON::ParserError] if there was invalid JSON in the response.
      #
      # @raise [HTTPError] if there was a problem with the HTTP response, such as
      #   an unexpected HTTP status code.
      #
      # @raise [AddressInvalidError] if the web service believes the IP address
      #   to be invalid or missing.
      #
      # @raise [AddressNotFoundError] if the IP address was not found.
      #
      # @raise [AddressReservedError] if the IP address is reserved.
      #
      # @raise [AuthenticationError] if there was a problem authenticating to the
      #   web service, such as an invalid or missing license key.
      #
      # @raise [InsufficientFundsError] if your account is out of credit.
      #
      # @raise [PermissionRequiredError] if your account does not have permission
      #   to use the web service.
      #
      # @raise [InvalidRequestError] if the web service responded with an error
      #   and there is no more specific error to raise.
      #
      # @return [MaxMind::GeoIP2::Model::City]
      def city(ip_address = 'me')
        response_for('city', MaxMind::GeoIP2::Model::City, ip_address)
      end

      # This method calls the GeoIP2 Precision Country web service.
      #
      # @param ip_address [String] IPv4 or IPv6 address as a string. If no
      #   address is provided, the address that the web service is called from is
      #   used.
      #
      # @raise [HTTP::Error] if there was an error performing the HTTP request,
      #   such as an error connecting.
      #
      # @raise [JSON::ParserError] if there was invalid JSON in the response.
      #
      # @raise [HTTPError] if there was a problem with the HTTP response, such as
      #   an unexpected HTTP status code.
      #
      # @raise [AddressInvalidError] if the web service believes the IP address
      #   to be invalid or missing.
      #
      # @raise [AddressNotFoundError] if the IP address was not found.
      #
      # @raise [AddressReservedError] if the IP address is reserved.
      #
      # @raise [AuthenticationError] if there was a problem authenticating to the
      #   web service, such as an invalid or missing license key.
      #
      # @raise [InsufficientFundsError] if your account is out of credit.
      #
      # @raise [PermissionRequiredError] if your account does not have permission
      #   to use the web service.
      #
      # @raise [InvalidRequestError] if the web service responded with an error
      #   and there is no more specific error to raise.
      #
      # @return [MaxMind::GeoIP2::Model::Country]
      def country(ip_address = 'me')
        response_for('country', MaxMind::GeoIP2::Model::Country, ip_address)
      end

      # This method calls the GeoIP2 Precision Insights web service.
      #
      # @param ip_address [String] IPv4 or IPv6 address as a string. If no
      #   address is provided, the address that the web service is called from is
      #   used.
      #
      # @raise [HTTP::Error] if there was an error performing the HTTP request,
      #   such as an error connecting.
      #
      # @raise [JSON::ParserError] if there was invalid JSON in the response.
      #
      # @raise [HTTPError] if there was a problem with the HTTP response, such as
      #   an unexpected HTTP status code.
      #
      # @raise [AddressInvalidError] if the web service believes the IP address
      #   to be invalid or missing.
      #
      # @raise [AddressNotFoundError] if the IP address was not found.
      #
      # @raise [AddressReservedError] if the IP address is reserved.
      #
      # @raise [AuthenticationError] if there was a problem authenticating to the
      #   web service, such as an invalid or missing license key.
      #
      # @raise [InsufficientFundsError] if your account is out of credit.
      #
      # @raise [PermissionRequiredError] if your account does not have permission
      #   to use the web service.
      #
      # @raise [InvalidRequestError] if the web service responded with an error
      #   and there is no more specific error to raise.
      #
      # @return [MaxMind::GeoIP2::Model::Insights]
      def insights(ip_address = 'me')
        response_for('insights', MaxMind::GeoIP2::Model::Insights, ip_address)
      end

      private

      def response_for(endpoint, model_class, ip_address)
        record = get(endpoint, ip_address)

        model_class.new(record, @locales)
      end

      def make_http_client
        headers = HTTP.basic_auth(user: @account_id, pass: @license_key)
                      .headers(
                        accept: 'application/json',
                        user_agent: 'MaxMind-GeoIP2-ruby',
                      )
        timeout = @timeout > 0 ? headers.timeout(@timeout) : headers

        proxy = timeout
        if @proxy_address != ''
          opts = {}
          opts[:proxy_port] = @proxy_port if @proxy_port != 0
          opts[:proxy_username] = @proxy_username if @proxy_username != ''
          opts[:proxy_password] = @proxy_password if @proxy_password != ''
          proxy = timeout.via(@proxy_address, opts)
        end

        proxy
      end

      def get(endpoint, ip_address)
        url = "/geoip/v2.1/#{endpoint}/#{ip_address}"

        response = nil
        body = nil
        @connection_pool.with do |client|
          response = client.get(url)
          body = response.to_s
        end

        is_json = response.headers[:content_type]&.include?('json')

        if response.status.client_error?
          return handle_client_error(endpoint, response.code, body, is_json)
        end

        if response.status.server_error?
          raise HTTPError,
                "Received server error response (#{response.code}) for #{endpoint} with body #{body}"
        end

        if response.code != 200
          raise HTTPError,
                "Received unexpected response (#{response.code}) for #{endpoint} with body #{body}"
        end

        handle_success(endpoint, body, is_json)
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      def handle_client_error(endpoint, status, body, is_json)
        if !is_json
          raise HTTPError,
                "Received client error response (#{status}) for #{endpoint} but it is not JSON: #{body}"
        end

        error = JSON.parse(body)

        if !error.key?('code') || !error.key?('error')
          raise HTTPError,
                "Received client error response (#{status}) that is JSON but does not specify code or error keys: #{body}"
        end

        case error['code']
        when 'IP_ADDRESS_INVALID', 'IP_ADDRESS_REQUIRED'
          raise AddressInvalidError, error['error']
        when 'IP_ADDRESS_NOT_FOUND'
          raise AddressNotFoundError, error['error']
        when 'IP_ADDRESS_RESERVED'
          raise AddressReservedError, error['error']
        when 'ACCOUNT_ID_REQUIRED',
              'ACCOUNT_ID_UNKNOWN',
              'AUTHORIZATION_INVALID',
              'LICENSE_KEY_REQUIRED'
          raise AuthenticationError, error['error']
        when 'INSUFFICIENT_FUNDS'
          raise InsufficientFundsError, error['error']
        when 'PERMISSION_REQUIRED'
          raise PermissionRequiredError, error['error']
        else
          raise InvalidRequestError, error['error']
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      def handle_success(endpoint, body, is_json)
        if !is_json
          raise HTTPError,
                "Received a success response for #{endpoint} but it is not JSON: #{body}"
        end

        JSON.parse(body)
      end
    end
  end
end
