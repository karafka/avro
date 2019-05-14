# frozen_string_literal: true

RSpec.describe Karafka::Parsers::Avro do
  it { expect { Karafka::Parsers::Avro::VERSION }.not_to raise_error }
end
