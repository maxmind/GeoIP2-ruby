# frozen_string_literal: true

require 'ipaddr'

module MaxMind
  module GeoIP2
    module Model
      # @!visibility private
      class Abstract
        def initialize(record)
          @record = record

          ip = IPAddr.new(record['ip_address']).mask(record['prefix_length'])
          record['network'] = format('%s/%d', ip.to_s, record['prefix_length'])
        end

        protected

        def get(key)
          if @record.nil? || !@record.key?(key)
            return false if key.start_with?('is_')

            return nil
          end

          @record[key]
        end
      end
    end
  end
end
