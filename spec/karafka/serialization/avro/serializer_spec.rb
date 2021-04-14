# frozen_string_literal: true

RSpec.describe Karafka::Serialization::Avro::Serializer do
  subject(:serializer) { described_class.new(avro, schema_name: schema_name) }

  let(:avro) { AvroTurf.new(schemas_path: 'spec/fixtures/schemas/') }
  let(:schema_name) { 'person' }

  describe '.call' do

    context 'when content can be serialized with #to_json' do
      let(:content) { { 'name' => 'Bob', 'email' => 'bob@gmail.com', 'motto' => 'Use Avro every day' } }

      it 'expect to serialize it that way' do
        expect(avro.decode(serializer.call(content))).to eq content
      end
    end
  end
end