module JSONAPI
  module Client
    module ResourceSerialization

      def as_json(*)
        attributes.slice(:id, :type) do |json|
          # relationships.as_json.tap do |relations|
          #   json[:relationships] = relations unless relations.empty?
          # end
          json[:attributes] = attributes.except(:id, :type).as_json
        end
      end

      def as_jsonapi(*)
        attributes.slice(:id, :type) do |json|
          # relationships.as_json.tap do |relations|
          #   json[:relationships] = relations unless relations.empty?
          # end
          json[:attributes] = attributes_for_serialization
        end
      end

      private

      def attributes_for_serialization
        attributes.except(*self.class.readonly_attributes) #.slice(*changed)
      end
    end
  end
end
