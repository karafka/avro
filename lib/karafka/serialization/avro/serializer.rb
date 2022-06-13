require 'avro_turf'
require 'avro_turf/messaging'

module Karafka
  # Module for all supported by default serialization and deserialization ways
  module Serialization
    # Namespace for json ser/der
    module Avro
      # Default Karafka Avro serializer for writing avro data
      class Serializer
        def self.from_registry(schema_name, version = nil)
          Serializer.new(Karafka::Serialization::Avro.get_avro_with_registry, schema_name: schema_name, version: version)
        end

        def self.from_registry_with_subject(subject, version)
          Serializer.new(Karafka::Serialization::Avro.get_avro_with_registry, subject: subject, version: version)
        end

        def self.from_path(schema_name, codec: nil)
          @schemas_path = Karafka::Serialization::Avro.schemas_path
          raise ArgumentError, 'You have to specify schemas_path first' if @schemas_path.nil?

          Serializer.new(AvroTurf.new(schemas_path: @schemas_path, codec: codec), schema_name: schema_name)
        end

        attr_reader :avro, :schema_name, :subject, :version

        def initialize(avro, subject: nil, version: 1, schema_name: nil)
          @avro = avro
          @subject = subject
          @version = version
          @schema_name = schema_name
        end

        def call(content)
          if subject
            avro.encode(content, subject: subject, version: version)
          else
            avro.encode(content, schema_name: schema_name)
          end
          rescue AvroTurf::Error => e
            raise ::Karafka::Errors::SerializationError, e
        end
      end
    end
  end
end
