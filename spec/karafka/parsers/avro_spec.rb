require 'spec_helper'

RSpec.describe Karafka::Parsers::Avro do
  let(:schema) { 'person' }

  before do
    described_class.registry_url = nil
    described_class.schemas_path = nil
  end

  describe '.from_path' do
    let(:schemas_path) { 'spec/fixtures/schemas' }

    describe 'when not configured' do
      it 'raises ArgumentError' do
        expect { described_class.from_path(schema).to raise_error(ArgumentError) }
      end
    end

    describe 'when configured' do
      before { described_class.schemas_path = schemas_path }

      it 'returns a Parser instance' do
        parser = described_class.from_path(schema)

        expect(parser).to be_a(Karafka::Parsers::Avro::Parser)
        expect(parser.avro).to be_a(AvroTurf)
      end

      it 'can pass a codec' do
        codec = 'deflate'

        expect(AvroTurf).to receive(:new).with(schemas_path: schemas_path, codec: codec)

        parser = described_class.from_path(schema, codec: codec)
      end
    end
  end

  describe '.from_registry' do
    let(:registry_url) { 'http://my-registry:8081' }

    describe 'when not configured' do
      it 'raises ArgumentError' do
        expect { described_class.from_registry(schema).to raise_error(ArgumentError) }
      end
    end

    describe 'when configured' do
      before { described_class.registry_url = registry_url }

      it 'returns a Parser instance' do
        parser = described_class.from_registry(schema)

        expect(parser).to be_a(Karafka::Parsers::Avro::Parser)
        expect(parser.avro).to be_a(AvroTurf::Messaging)
      end
    end
  end
end
