# frozen_string_literal: true

RSpec.describe Karafka::Serialization::Avro::Deserializer do
  subject(:deserializer) { described_class.new(avro, schema_name) }

  let(:avro) { AvroTurf.new(schemas_path: 'spec/fixtures/schemas/') }
  let(:schema_name) { 'person' }

  let(:params) do
    metadata = ::Karafka::Params::Metadata.new
    metadata['deserializer'] = deserializer

    ::Karafka::Params::Params.new(
      raw_payload,
      metadata
    )
  end

  describe '.call' do
    context 'when we can deserialize given raw_payload' do
      let(:content_source) do
        { 'name' => 'Bob', 'email' => 'bob@example.com', 'motto' => 'Use Avro every day' }
      end
      let(:raw_payload) { avro.encode(content_source, schema_name: schema_name) }

      it 'expect to deserialize' do
        expect(params.payload).to eq content_source
      end
    end

    context 'when raw_payload is malformatted' do
      let(:raw_payload) { 'abc' }
      let(:expected_error) { Karafka::Errors::DeserializationError }

      it 'expect to raise with Karafka internal deserializing error' do
        expect { params.payload }.to raise_error(expected_error)
      end
    end
  end
end
