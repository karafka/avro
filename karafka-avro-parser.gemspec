# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'karafka/parsers/avro/version'

Gem::Specification.new do |spec|
  spec.name          = 'karafka-avro-parser'
  spec.version       = Karafka::Parsers::Avro::VERSION
  spec.authors       = ['Kacper Madej']
  spec.email         = %w[kacperoza@gmail.com]

  spec.summary       = %q{Apache Avro support for Karafka}
  spec.description   = %q{}
  spec.homepage      = 'https://github.com/karafka/avro'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = %w[lib]

  spec.add_dependency 'avro_turf', '~> 0.8'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
