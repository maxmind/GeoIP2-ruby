# frozen_string_literal: true

module MaxMind::GeoIP2::Record
  class Abstract # :nodoc:
    def initialize(record)
      @record = record
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
