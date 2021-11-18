# frozen_string_literal: true

require 'maxmind/db'
require 'maxmind/geoip2/errors'
require 'maxmind/geoip2/model/anonymous_ip'
require 'maxmind/geoip2/model/asn'
require 'maxmind/geoip2/model/city'
require 'maxmind/geoip2/model/connection_type'
require 'maxmind/geoip2/model/country'
require 'maxmind/geoip2/model/domain'
require 'maxmind/geoip2/model/enterprise'
require 'maxmind/geoip2/model/isp'

module MaxMind
  module GeoIP2
    # Reader is a reader for the GeoIP2/GeoLite2 database format. IP addresses
    # can be looked up using the database specific methods.
    #
    # == Example
    #
    #   require 'maxmind/geoip2'
    #
    #   reader = MaxMind::GeoIP2::Reader.new(database: 'GeoIP2-Country.mmdb')
    #
    #   record = reader.country('1.2.3.4')
    #   puts record.country.iso_code
    #
    #   reader.close
    class Reader
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity

      # Create a Reader for looking up IP addresses in a GeoIP2/GeoLite2 database
      # file.
      #
      # If you're performing multiple lookups, it's most efficient to create one
      # Reader and reuse it.
      #
      # Once created, the Reader is safe to use for lookups from multiple
      # threads. It is safe to use after forking.
      #
      # @overload initialize(database:, locales: ['en'], mode: MaxMind::DB::MODE_AUTO)
      #   @param database [String] a path to a GeoIP2/GeoLite2 database file.
      #   @param locales [Array<String>] a list of locale codes to use in the name
      #     property from most preferred to least preferred.
      #   @param mode [Symbol] Defines how to open the database. It may be one of
      #     MaxMind::DB::MODE_AUTO, MaxMind::DB::MODE_FILE, or
      #     MaxMind::DB::MODE_MEMORY. If you don't provide one, the Reader uses
      #     MaxMind::DB::MODE_AUTO. Refer to the definition of those constants in
      #     MaxMind::DB for an explanation of their meaning.
      #
      # @raise [MaxMind::DB::InvalidDatabaseError] if the database is corrupt
      #   or invalid.
      #
      # @raise [ArgumentError] if the mode is invalid.
      def initialize(*args)
        # This if statement is to let us support calling as though we are using
        # Ruby 2.0 keyword arguments. We can't use keyword argument syntax as
        # we want to be backwards compatible with the old way we accepted
        # parameters, which looked like:
        # def initialize(database, locales = ['en'], options = {})
        if args.length == 1 && args[0].instance_of?(Hash)
          database = args[0][:database]
          locales = args[0][:locales]
          mode = args[0][:mode]
        else
          database = args[0]
          locales = args[1]
          mode = args[2].instance_of?(Hash) ? args[2][:mode] : nil
        end

        if !database.instance_of?(String)
          raise ArgumentError, 'Invalid database parameter'
        end

        locales = ['en'] if locales.nil? || locales.empty?

        options = {}
        options[:mode] = mode if !mode.nil?
        @reader = MaxMind::DB.new(database, options)

        @type = @reader.metadata.database_type

        @locales = locales
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      # Look up the IP address in the database.
      #
      # @param ip_address [String] a string in the standard notation. It may be
      #   IPv4 or IPv6.
      #
      # @return [MaxMind::GeoIP2::Model::AnonymousIP]
      #
      # @raise [ArgumentError] if used against a non-Anonymous IP database or if
      #   you attempt to look up an IPv6 address in an IPv4 only database.
      #
      # @raise [AddressNotFoundError] if the IP address is not found in the
      #   database.
      #
      # @raise [MaxMind::DB::InvalidDatabaseError] if the database appears
      #   corrupt.
      def anonymous_ip(ip_address)
        flat_model_for(
          Model::AnonymousIP,
          'anonymous_ip',
          'GeoIP2-Anonymous-IP',
          ip_address,
        )
      end

      # Look up the IP address in an ASN database.
      #
      # @param ip_address [String] a string in the standard notation. It may be
      #   IPv4 or IPv6.
      #
      # @return [MaxMind::GeoIP2::Model::ASN]
      #
      # @raise [ArgumentError] if used against a non-ASN database or if you
      #   attempt to look up an IPv6 address in an IPv4 only database.
      #
      # @raise [AddressNotFoundError] if the IP address is not found in the
      #   database.
      #
      # @raise [MaxMind::DB::InvalidDatabaseError] if the database appears
      #   corrupt.
      def asn(ip_address)
        flat_model_for(Model::ASN, 'asn', 'GeoLite2-ASN', ip_address)
      end

      # Look up the IP address in a City database.
      #
      # @param ip_address [String] a string in the standard notation. It may be
      #   IPv4 or IPv6.
      #
      # @return [MaxMind::GeoIP2::Model::City]
      #
      # @raise [ArgumentError] if used against a non-City database or if you
      #   attempt to look up an IPv6 address in an IPv4 only database.
      #
      # @raise [AddressNotFoundError] if the IP address is not found in the
      #   database.
      #
      # @raise [MaxMind::DB::InvalidDatabaseError] if the database appears
      #   corrupt.
      def city(ip_address)
        model_for(Model::City, 'city', 'City', ip_address)
      end

      # Look up the IP address in a Connection Type database.
      #
      # @param ip_address [String] a string in the standard notation. It may be
      #   IPv4 or IPv6.
      #
      # @return [MaxMind::GeoIP2::Model::ConnectionType]
      #
      # @raise [ArgumentError] if used against a non-Connection Type database or if
      #   you attempt to look up an IPv6 address in an IPv4 only database.
      #
      # @raise [AddressNotFoundError] if the IP address is not found in the
      #   database.
      #
      # @raise [MaxMind::DB::InvalidDatabaseError] if the database appears
      #   corrupt.
      def connection_type(ip_address)
        flat_model_for(
          Model::ConnectionType,
          'connection_type',
          'GeoIP2-Connection-Type',
          ip_address,
        )
      end

      # Look up the IP address in a Country database.
      #
      # @param ip_address [String] a string in the standard notation. It may be
      #   IPv4 or IPv6.
      #
      # @return [MaxMind::GeoIP2::Model::Country]
      #
      # @raise [ArgumentError] if used against a non-Country database or if you
      #   attempt to look up an IPv6 address in an IPv4 only database.
      #
      # @raise [AddressNotFoundError] if the IP address is not found in the
      #   database.
      #
      # @raise [MaxMind::DB::InvalidDatabaseError] if the database appears
      #   corrupt.
      def country(ip_address)
        model_for(Model::Country, 'country', 'Country', ip_address)
      end

      # Look up the IP address in a Domain database.
      #
      # @param ip_address [String] a string in the standard notation. It may be
      #   IPv4 or IPv6.
      #
      # @return [MaxMind::GeoIP2::Model::Domain]
      #
      # @raise [ArgumentError] if used against a non-Domain database or if you
      #   attempt to look up an IPv6 address in an IPv4 only database.
      #
      # @raise [AddressNotFoundError] if the IP address is not found in the
      #   database.
      #
      # @raise [MaxMind::DB::InvalidDatabaseError] if the database appears
      #   corrupt.
      def domain(ip_address)
        flat_model_for(Model::Domain, 'domain', 'GeoIP2-Domain', ip_address)
      end

      # Look up the IP address in an Enterprise database.
      #
      # @param ip_address [String] a string in the standard notation. It may be
      #   IPv4 or IPv6.
      #
      # @return [MaxMind::GeoIP2::Model::Enterprise]
      #
      # @raise [ArgumentError] if used against a non-Enterprise database or if
      #   you attempt to look up an IPv6 address in an IPv4 only database.
      #
      # @raise [AddressNotFoundError] if the IP address is not found in the
      #   database.
      #
      # @raise [MaxMind::DB::InvalidDatabaseError] if the database appears
      #   corrupt.
      def enterprise(ip_address)
        model_for(Model::Enterprise, 'enterprise', 'Enterprise', ip_address)
      end

      # Look up the IP address in an ISP database.
      #
      # @param ip_address [String] a string in the standard notation. It may be
      #   IPv4 or IPv6.
      #
      # @return [MaxMind::GeoIP2::Model::ISP]
      #
      # @raise [ArgumentError] if used against a non-ISP database or if you
      #   attempt to look up an IPv6 address in an IPv4 only database.
      #
      # @raise [AddressNotFoundError] if the IP address is not found in the
      #   database.
      #
      # @raise [MaxMind::DB::InvalidDatabaseError] if the database appears
      #   corrupt.
      def isp(ip_address)
        flat_model_for(Model::ISP, 'isp', 'GeoIP2-ISP', ip_address)
      end

      # Return the metadata associated with the database.
      #
      # @return [MaxMind::DB::Metadata]
      def metadata
        @reader.metadata
      end

      # Close the Reader and return resources to the system.
      #
      # @return [void]
      def close
        @reader.close
      end

      private

      def model_for(model_class, method, type, ip_address)
        record, prefix_length = get_record(method, type, ip_address)

        record['traits'] = {} if !record.key?('traits')
        record['traits']['ip_address'] = ip_address
        record['traits']['prefix_length'] = prefix_length

        model_class.new(record, @locales)
      end

      def get_record(method, type, ip_address)
        if !@type.include?(type)
          raise ArgumentError,
                "The #{method} method cannot be used with the #{@type} database."
        end

        record, prefix_length = @reader.get_with_prefix_length(ip_address)

        if record.nil?
          raise AddressNotFoundError,
                "The address #{ip_address} is not in the database."
        end

        [record, prefix_length]
      end

      def flat_model_for(model_class, method, type, ip_address)
        record, prefix_length = get_record(method, type, ip_address)

        record['ip_address'] = ip_address
        record['prefix_length'] = prefix_length

        model_class.new(record)
      end
    end
  end
end
