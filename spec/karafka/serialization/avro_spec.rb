# frozen_string_literal: true

RSpec.describe Karafka::Serialization::Avro do
  let(:schema) { 'person' }

  before do
    described_class.registry_url = nil
    described_class.schemas_path = nil
  end

  xdescribe '.from_path' do
    subject(:from_path) { described_class.from_path(schema) }

    let(:schemas_path) { 'spec/fixtures/schemas' }

    context 'when not configured' do
      it { expect { from_path }.to raise_error(ArgumentError) }
    end

    context 'when configured' do
      before { described_class.schemas_path = schemas_path }

      it { is_expected.to be_a(Karafka::Serialization::Avro::Serializer) }
      it { expect(from_path.avro).to be_a(AvroTurf) }

      context 'when codec is passed' do
        subject(:from_path) { described_class.from_path(schema, codec: codec) }

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

  xdescribe '.from_registry' do
    subject(:from_registry) { described_class.from_registry(schema) }

    let(:registry_url) { 'http://my-registry:8081' }

    context 'when not configured' do
      it { expect { from_registry }.to raise_error(ArgumentError) }
    end

    context 'when configured' do
      before { described_class.registry_url = registry_url }

      it { is_expected.to be_a(Karafka::Parsers::Avro::Parser) }
      it { expect(from_registry.avro).to be_a(AvroTurf::Messaging) }

      context 'when the schema name is not passed' do
        subject(:from_registry) { described_class.from_registry }

        it { is_expected.to be_a(Karafka::Parsers::Avro::Parser) }
        it { expect(from_registry.avro).to be_a(AvroTurf::Messaging) }
      end
    end
  end
end
