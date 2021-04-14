require 'avro_turf'
require 'avro_turf/messaging'

require_relative 'avro/deserializer'
require_relative 'avro/serializer'

module Karafka
  module Serialization
    module Avro
      def self.registry_url=(registry_url)
        @registry_url = registry_url
      end

      def self.schemas_path=(schemas_path)
        @schemas_path = schemas_path
      end

      def self.registry_url
        @registry_url
      end

      def self.schemas_path
        @schemas_path
      end
    end
  end
end
