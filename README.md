# Karafka::Avro::Serialization

Karafka (De)Serializer for [Apache Avro](http://avro.apache.org/). It uses the great [AvroTurf](https://github.com/dasch/avro_turf) gem by under the hood.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'karafka-avro-serialization'
```

And then execute:

    $ bundle

## Usage

Thanks to Karafka's modular design, you only have to define a `deserializer` the moment you draw your consumer groups.
You can also define a `serializer` for responders.
### Consumer

#### Example with Schema Folder

```ruby
Karafka::Serialization::Avro.schemas_path = 'app/schemas'

App.consumer_groups.draw do
  consumer_group :my_consumer_group do
    topic :my_topic do
      consumer AvroConsumer
      deserializer Karafka::Serialization::Avro::Deserializer.from_path('schema_name')
    end
  end
end
```

#### Example with a Codec

```ruby
Karafka::Serialization::Avro.schemas_path = 'app/schemas'

App.consumer_groups.draw do
  consumer_group :my_consumer_group do
    topic :my_topic do
      consumer AvroConsumer
      deserializer Karafka::Serialization::Avro::Deserializer.from_path('schema_name', codec: 'deflate')
    end
  end
end
```

#### Example with Schema Registry

```ruby
Karafka::Serialization::Avro.registry_url = 'http://my-registry:8081/'

App.consumer_groups.draw do
  consumer_group :my_consumer_group do
    topic :my_topic do
      consumer AvroConsumer
      deserializer Karafka::Serialization::Avro::Deserializer.from_registry('schema_name')
    end
  end
end
```

*Note: `schema_name` is not specifically required when using a schema registry, as the schema id is contained within the message, it can be passed in optionally if you are using one schema per topic*

### Responder

The schema path or registry url should be set like the consumer examples show.

#### Example with Schema Folder
```ruby
class Responder < ApplicationResponder
  topic :my_topic,
        serializer: Karafka::Serialization::Avro::Serializer.from_path('schema_name')

  def respond(data)
    respond_to :my_topic,
               data
  end
end
```

#### Example with Schema Registry and automatic upload of the schema to the registry
```ruby
class Responder < ApplicationResponder
  topic :my_topic,
        serializer: Karafka::Serialization::Avro::Serializer.from_registry('schema_name')

  def respond(data)
    respond_to :my_topic,
               data
  end
end
```

#### Example with Schema Registry and preexisting a schema from the registry
```ruby
class Responder < ApplicationResponder
  topic :my_topic,
        serializer: Karafka::Serialization::Avro::Serializer.from_registry_with_subject('subject', 1)

  def respond(data)
    respond_to :my_topic,
               data
  end
end
```

## Note on contributions

First, thank you for considering contributing to Karafka! It's people like you that make the open source community such a great community!

Each pull request must pass all the RSpec specs and meet our quality requirements.

To check if everything is as it should be, we use [Coditsu](https://coditsu.io) that combines multiple linters and code analyzers for both code and documentation. Once you're done with your changes, submit a pull request.

Coditsu will automatically check your work against our quality standards. You can find your commit check results on the [builds page](https://app.coditsu.io/karafka/commit_builds) of Karafka organization.

[![coditsu](https://coditsu.io/assets/quality_bar.svg)](https://app.coditsu.io/karafka-avro/commit_builds)
