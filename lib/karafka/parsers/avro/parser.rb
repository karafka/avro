require 'avro_turf'
require 'avro_turf/messaging'

module Karafka
  module Parsers
    module Avro
      class Parser
        def initialize(avro, schema_name)
          @avro = avro
          @schema_name = schema_name
        end

        def parse(content)
          @avro.decode(content, schema_name: @schema_name)
        end

        def generate(content)
          @avro.encode(content, schema_name: @schema_name)
        end
      end
    end
  end
end
