require 'spec_helper'

RSpec.describe Karafka::Parsers::Avro::Parser do
  let(:avro) { AvroTurf.new(schemas_path: 'spec/fixtures/schemas/') }
  let(:schema_name) { 'person' }

  subject(:parser) { described_class.new(avro, schema_name) }

  describe '#generate' do
    describe 'when the input matches the schema' do
      let(:input) { {name: 'Bob', email: 'bob@gmail.com', motto: 'Use Avro every day'}}

      it 'doesnt throw an error' do
        expect { parser.generate(input) }.not_to raise_error
      end
    end

    describe 'when the input doesnt match the schema' do
      let(:input) { {name: 'Bob'} }

      it 'throws an error' do
        expect { parser.generate(input) }.to raise_error(Avro::IO::AvroTypeError)
      end
    end
  end

  describe '#parse' do
    describe 'when the input is valid' do
      let(:raw) { {'name' => 'Bob', 'email' => 'bob@gmail.com', 'motto' => 'Use Avro every day'} }
      let(:input) { parser.generate(raw) }

      it 'returns parsed input' do
        expect(parser.parse(input)).to eq raw
      end
    end

    describe 'when the input is invalid' do
      let(:input) { '1234' }

      it 'throws an error' do
        expect { parser.parse(input) }.to raise_error(Avro::DataFile::DataFileError)
      end
    end
  end
end
