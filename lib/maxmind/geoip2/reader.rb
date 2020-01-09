# frozen_string_literal: true

require 'maxmind/db'
require 'maxmind/geoip2/errors'
require 'maxmind/geoip2/model/city'
require 'maxmind/geoip2/model/country'
require 'maxmind/geoip2/model/enterprise'

module MaxMind::GeoIP2
  # Reader is a reader for the GeoIP2/GeoLite2 database format. IP addresses
  # can be looked up using the database specific methods.
  #
  # == Example
  #
  #   require 'maxmind/geoip2'
  #
  #   reader = MaxMind::GeoIP2::Reader.new('GeoIP2-Country.mmdb')
  #
  #   record = reader.country('1.2.3.4')
  #   puts record.country.iso_code
  #
  #   reader.close
  class Reader
    # Create a Reader for looking up IP addresses in a GeoIP2/GeoLite2 database
    # file.
    #
    # If you're performing multiple lookups, it's most efficient to create one
    # Reader and reuse it.
    #
    # Once created, the Reader is safe to use for lookups from multiple
    # threads. It is safe to use after forking only if you use
    # MaxMind::DB::MODE_MEMORY or if your version of Ruby supports IO#pread.
    #
    # Creating the Reader may raise an exception if initialization fails.
    #
    # +database+ is a path to a GeoIP2/GeoLite2 database file.
    #
    # +locales+ is a list of locale codes to use in the name property from most
    # preferred to least preferred.
    #
    # +options+ is an option hash where each key is a symbol. The options
    # control the behavior of the Reader.
    #
    # The available options are:
    #
    # [+:mode+] defines how to open the database. It may be one of
    #           MaxMind::DB::MODE_AUTO, MaxMind::DB::MODE_FILE, or
    #           MaxMind::DB::MODE_MEMORY. If you don't provide one, the Reader uses
    #           MaxMind::DB::MODE_AUTO. Refer to the definition of those constants
    #           in MaxMind::DB for an explanation of their meaning.
    #
    # === Exceptions
    #
    # Raises a MaxMind::DB::InvalidDatabaseError if the database is corrupt or
    # invalid. It can raise other exceptions, such as ArgumentError, if other
    # errors occur.
    def initialize(database, locales = ['en'], options = {})
      @reader = MaxMind::DB.new(database, options)
      @type = @reader.metadata.database_type
      locales = ['en'] if locales.empty?
      @locales = locales
    end

    # Look up the +ip_address+ in the database and returns a
    # MaxMind::GeoIP2::Model::City object.
    #
    # +ip_address+ is a string in the standard notation. It may be IPv4 or
    # IPv6.
    #
    # === Exceptions
    #
    # Raises an ArgumentError if used against a non-City database or if you
    # attempt to look up an IPv6 address in an IPv4 only database.
    #
    # Raises an AddressNotFoundError if +ip_address+ is not found in the
    # database.
    #
    # Raises a MaxMind::DB::InvalidDatabaseError if the database appears
    # corrupt.
    def city(ip_address)
      model_for(Model::City, 'city', 'City', ip_address)
    end

    # Look up the +ip_address+ in the database and returns a
    # MaxMind::GeoIP2::Model::Country object.
    #
    # +ip_address+ is a string in the standard notation. It may be IPv4 or
    # IPv6.
    #
    # === Exceptions
    #
    # Raises an ArgumentError if used against a non-Country database or if you
    # attempt to look up an IPv6 address in an IPv4 only database.
    #
    # Raises an AddressNotFoundError if +ip_address+ is not found in the
    # database.
    #
    # Raises a MaxMind::DB::InvalidDatabaseError if the database appears
    # corrupt.
    def country(ip_address)
      model_for(Model::Country, 'country', 'Country', ip_address)
    end

    # Look up the +ip_address+ in the database and returns a
    # MaxMind::GeoIP2::Model::Enterprise object.
    #
    # +ip_address+ is a string in the standard notation. It may be IPv4 or
    # IPv6.
    #
    # === Exceptions
    #
    # Raises an ArgumentError if used against a non-Enterprise database or if
    # you attempt to look up an IPv6 address in an IPv4 only database.
    #
    # Raises an AddressNotFoundError if +ip_address+ is not found in the
    # database.
    #
    # Raises a MaxMind::DB::InvalidDatabaseError if the database appears
    # corrupt.
    def enterprise(ip_address)
      model_for(Model::Enterprise, 'enterprise', 'Enterprise', ip_address)
    end

    # Return the metadata associated with the database as a
    # MaxMind::DB::Metadata object.
    def metadata
      @reader.metadata
    end

    # Close the Reader and return resources to the system.
    #
    # There is no useful return value. #close raises an exception if there is
    # an error.
    def close
      @reader.close
    end

    private

    def model_for(model_class, method, type, ip_address)
      if !@type.include?(type)
        raise ArgumentError,
              "The #{method} method cannot be used with the #{@type} database."
      end

      record, prefix_length = @reader.get_with_prefix_length(ip_address)

      if record.nil?
        raise AddressNotFoundError,
              "The address #{ip_address} is not in the database."
      end

      record['traits'] = {} if !record.key?('traits')
      record['traits']['ip_address'] = ip_address
      record['traits']['prefix_length'] = prefix_length

      model_class.new(record, @locales)
    end
  end
end
