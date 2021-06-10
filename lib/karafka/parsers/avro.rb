require 'avro_turf'
require 'avro_turf/messaging'

require_relative 'avro/parser'
require_relative 'avro/version'

module Karafka
  module Parsers
    module Avro
      def self.registry_url=(registry_url)
        @registry_url = registry_url
      end

      def self.schemas_path=(schemas_path)
        @schemas_path = schemas_path
      end

      def self.from_registry(schema_name = nil)
        raise ArgumentError, 'You have to specify registry_path first' if @registry_url.nil?

        Parser.new(AvroTurf::Messaging.new(registry_url: @registry_url), schema_name)
      end

      def self.from_path(schema_name, codec: nil)
        raise ArgumentError, 'You have to specify schemas_path first' if @schemas_path.nil?

        Parser.new(AvroTurf.new(schemas_path: @schemas_path, codec: codec), schema_name)
      end
    end
  end
end
