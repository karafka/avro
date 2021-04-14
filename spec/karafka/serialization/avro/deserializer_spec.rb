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

  before do
    Karafka::Serialization::Avro.registry_url = nil
    Karafka::Serialization::Avro.schemas_path = nil
  end

  describe '#from_path' do
    subject(:from_path) { described_class.from_path(schema_name) }

    let(:schemas_path) { 'spec/fixtures/schemas' }

    context 'when not configured' do
      it { expect { from_path }.to raise_error(ArgumentError) }
    end

    context 'when configured' do
      before { Karafka::Serialization::Avro.schemas_path = schemas_path }

      it { is_expected.to be_a(Karafka::Serialization::Avro::Deserializer) }
      it { expect(from_path.avro).to be_a(AvroTurf) }

      context 'when codec is passed' do
        subject(:from_path) { described_class.from_path(schema_name, codec: codec) }

        let(:codec) { 'deflate' }

        before do
          allow(AvroTurf).to receive(:new).with(schemas_path: schemas_path, codec: codec)
          from_path
        end

        it do
          expect(AvroTurf).to have_received(:new).with(schemas_path: schemas_path, codec: codec)
        end
      end
    end
  end

  describe '#from_registry' do
    subject(:from_registry) { described_class.from_registry(schema_name) }

    let(:registry_url) { 'http://my-registry:8081' }

    context 'when not configured' do
      it { expect { from_registry }.to raise_error(ArgumentError) }
    end

    context 'when configured' do
      before { Karafka::Serialization::Avro.registry_url = registry_url }

      it { is_expected.to be_a(Karafka::Serialization::Avro::Deserializer) }
      it { expect(from_registry.avro).to be_a(AvroTurf::Messaging) }

      context 'when the schema name is not passed' do
        subject(:from_registry) { described_class.from_registry }

        it { is_expected.to be_a(Karafka::Serialization::Avro::Deserializer) }
        it { expect(from_registry.avro).to be_a(AvroTurf::Messaging) }
      end
    end
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
