# frozen_string_literal: true

require 'avro_turf'
require 'avro_turf/messaging'

module Karafka
  module Parsers
    module Avro
      class Parser
        attr_reader :avro, :schema_name

        def initialize(avro, schema_name)
          @avro = avro
          @schema_name = schema_name
        end

        def parse(content)
          avro.decode(content, schema_name: schema_name)
        end

        def generate(content)
          avro.encode(content, schema_name: schema_name)
        end
      end
    end
  end
end
