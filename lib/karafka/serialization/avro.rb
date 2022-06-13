require 'avro_turf'
require 'avro_turf/messaging'

require_relative 'avro/deserializer'
require_relative 'avro/serializer'

module Karafka
  module Serialization
    module Avro
      mattr_accessor :registry_url, :schemas_path,
                     :user, :password,
                     :ssl_ca_file,
                     :client_cert, :client_key, :client_key_pass,
                     :client_cert_data, :client_key_data
      
      def self.get_avro_with_registry
        raise ArgumentError, 'You have to specify registry_path first' if registry_url.nil?
        
        AvroTurf::Messaging.new(registry_url:, schemas_path:,
                                user: , password:,
                                ssl_ca_file:,
                                client_cert:, client_key:, client_key_pass:,
                                client_cert_data:, client_key_data:)
      end
    end
  end
end
