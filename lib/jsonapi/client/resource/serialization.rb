module JSONAPI
  module Client
    module Serialization

      # def as_json(*)
      #   attributes.slice(:id, :type) do |json|
      #     # relationships.as_json.tap do |relations|
      #     #   json[:relationships] = relations unless relations.empty?
      #     # end
      #     json[:attributes] = attributes.except(:id, :type).as_json
      #   end
      # end

      def as_jsonapi(options = {})
        attributes.slice(:id, :type).tap do |json|
          # relationships.as_json.tap do |relations|
          #   json[:relationships] = relations unless relations.empty?
          # end
          json[:attributes] = serialize_attributes(options)
        end
      end

      def from_jsonapi(json, options = {})
        # Array.wrap(json.fetch("data", [])).map do |data|
        #   # resource_class.new.tap do |resource|
        #   #   resource.attributes = deserialize_attributes(data)
        #   #   deserialize_errors(resource, data)
        #   #   deserialize_meta(resource, data)
        #   # end
        #   deserialize_root(json)
        # end

        self.attributes = deserialize_attributes(json, options)
      end

      private

      # def attributes_for_serialization
      #   attributes.except(*self.class.readonly_attributes) #.slice(*changed)
      # end

      # def serialize_root
      #   attributes.slice(:id, :type).tap do |json|
      #     json[:attributes] = serialize_attributes
      #   end
      # end

      def serialize_attributes(options)
        key_formatter = options.fetch(:key_formatter, self.key_formatter)

        attributes.except(*readonly_attributes).map do |key, value|
          { key_formatter.format(key) => value }
        end.inject({}, &:merge)
      end

      # def deserialize_root(json)
      #   self.attributes = deserialize_attributes(json)
      # end

      def deserialize_attributes(json, options)
        key_formatter = options.fetch(:key_formatter, self.key_formatter)

        json.fetch("attributes", {}).
          merge(json.slice("id", "links", "meta", "type", "relationships")).map do |key, value|

          { key_formatter.unformat(key) => value }
        end.inject({}, &:merge)
      end

      def deserialize_errors(json)
        # TODO
      end

      def deserialize_meta(json)
        # TODO
      end
    end
  end
end
