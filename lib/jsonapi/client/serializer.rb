module JSONAPI
  module Client
    class Serializer
      # extend Forwardable

      # def_delegators :resource_class,

      attr_reader :resource_class, :key_formatter

      def initialize(resource_class, options = {})
        @resource_class = resource_class
        @key_formatter = options.fetch(:key_formatter, JSONAPI::Client.configuration.key_formatter)
      end

      def serialize(resource)
        # TODO: Support serializing an array

        # resource.attributes.slice(:id, :type) do |json|
        #   # resource.relationships.as_json.tap do |relations|
        #   #   json[:relationships] = relations unless relations.empty?
        #   # end
        #   json[:attributes] = attributes_for_serialization(resource)
        # end

        {
          data: serialize_data(resource)
        }
      end

      def deserialize(json)

        Array.wrap(json.fetch("data", [])).map do |data|
          # resource_class.new.tap do |resource|
          #   resource.attributes = deserialize_attributes(data)
          #   deserialize_errors(resource, data)
          #   deserialize_meta(resource, data)
          # end
          deserialize_data(data)
        end

        # TODO: Consider returning a single object if the array size is 1 (or nil if empty!)

        # Array.wrap(json.fetch("data", [])).map do |data|
        #   JSONAPI::Client::Response.new.tap do |response|
        #     deserialize_data(data)
        #   end
        # end

      end

      private

      def serialize_data(resource)
        resource.attributes.slice(:id, :type).tap do |data|
          data[:attributes] = serialize_attributes(resource)
        end
      end

      def serialize_attributes(resource)
        resource.attributes.except(*resource_class.readonly_attributes).map do |key, value|
          { key_formatter.format(key) => value }
        end.inject({}, &:merge)
      end

      def deserialize_data(data)
        resource_class.new.tap do |resource|
          resource.attributes = deserialize_attributes(data)
        end
      end

      # TODO: Handle compound documents (ie. nested hashes)
      def deserialize_attributes(data)
        data.fetch("attributes", {}).
          merge(data.slice("id", "links", "meta", "type", "relationships")).map do |key, value|

          { key_formatter.unformat(key) => value }
        end.inject({}, &:merge)
      end

      def deserialize_errors(resource, data)
        # TODO
      end

      def deserialize_meta(resource, data)
        # TODO
      end
    end
  end
end