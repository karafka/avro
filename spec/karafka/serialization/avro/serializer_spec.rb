# frozen_string_literal: true

RSpec.describe Karafka::Serialization::Avro::Serializer do
  subject(:serializer) { described_class.new(avro, schema_name: schema_name) }

  let(:avro) { AvroTurf.new(schemas_path: 'spec/fixtures/schemas/') }
  let(:schema_name) { 'person' }

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

      it { is_expected.to be_a(Karafka::Serialization::Avro::Serializer) }
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

      it { is_expected.to be_a(Karafka::Serialization::Avro::Serializer) }
      it { expect(from_registry.avro).to be_a(AvroTurf::Messaging) }
    end
  end

  describe '.call' do
    context 'when content can be serialized with #to_json' do
      let(:content) { { 'name' => 'Bob', 'email' => 'bob@gmail.com', 'motto' => 'Use Avro every day' } }

      it 'expect to serialize it that way' do
        expect(avro.decode(serializer.call(content))).to eq content
      end
    end
  end
end