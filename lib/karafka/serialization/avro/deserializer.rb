require 'avro_turf'
require 'avro_turf/messaging'

# Default Karafka Avro deserializer for loading Avro data
module Karafka
  module Serialization
    module Avro
      class Deserializer
        def self.from_registry(schema_name = nil)
          Deserializer.new(Karafka::Serialization::Avro.get_avro_with_registry, schema_name)
        end

        def self.from_path(schema_name, codec: nil)
          @schemas_path = Karafka::Serialization::Avro.schemas_path
          raise ArgumentError, 'You have to specify schemas_path first' if @schemas_path.nil?

          Deserializer.new(AvroTurf.new(schemas_path: @schemas_path, codec: codec), schema_name)
        end

        attr_reader :avro, :schema_name

        def initialize(avro, schema_name)
          @avro = avro
          @schema_name = schema_name
        end

        def call(params)
          params.raw_payload.nil? ? nil : avro.decode(params.raw_payload, schema_name: schema_name)
        rescue AvroTurf::Error => e
          raise Karafka::Errors::DeserializationError, e
        end
      end
    end
  end
end
