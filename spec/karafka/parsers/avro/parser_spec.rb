# frozen_string_literal: true

RSpec.describe Karafka::Parsers::Avro::Parser do
  subject(:instance) { described_class.new(avro, schema_name) }

  let(:avro) { AvroTurf.new(schemas_path: 'spec/fixtures/schemas/') }
  let(:schema_name) { 'person' }

  describe '#generate' do
    context 'when the input matches the schema' do
      let(:input) { { name: 'Bob', email: 'bob@gmail.com', motto: 'Use Avro every day' } }

      it { expect { instance.generate(input) }.not_to raise_error }
    end

    context 'when the input doesnt match the schema' do
      let(:input) { { name: 'Bob' } }

      it { expect { instance.generate(input) }.to raise_error(Avro::IO::AvroTypeError) }
    end
  end

  describe '#parse' do
    context 'when the input is valid' do
      let(:raw) do
        { 'name' => 'Bob', 'email' => 'bob@gmail.com', 'motto' => 'Use Avro every day' }
      end
      let(:input) { instance.generate(raw) }

      it { expect(instance.parse(input)).to eq(raw) }
    end

    describe 'when the input is invalid' do
      let(:input) { '1234' }

      it { expect { instance.parse(input) }.to raise_error(Avro::DataFile::DataFileError) }
    end
  end
end
