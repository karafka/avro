# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'karafka/serialization/avro/version'

Gem::Specification.new do |spec|
  spec.name          = 'karafka-avro-serialization'
  spec.version       = Karafka::Serialization::Avro::VERSION
  spec.authors       = ['Kacper Madej', 'Marcel Hoppe']
  spec.email         = %w[kacperoza@gmail.com m.hoppe@newsaktuell.de]
  spec.homepage      = 'https://github.com/karafka/avro'
  spec.summary       = 'Apache Avro support for Karafka'
  spec.description   = ''
  spec.license       = 'LGPL-3.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = %w[lib]

  spec.required_ruby_version = '>= 2.5.0'

  spec.add_dependency 'avro_turf', '~> 1.3'
  spec.add_dependency 'karafka', '~> 1.4'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
