# frozen_string_literal: true

RSpec.describe Karafka::Serialization::Avro do
  it { expect { Karafka::Serialization::Avro::VERSION }.not_to raise_error }
end
