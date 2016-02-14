module JSONAPI
  module Client
    class Serializer
      attr_reader :klass, :options

      def initialize(klass, options = {})
        @klass = klass
        @options = options
      end

      def serialize(resource_or_array)
        {
          data: if resource_or_array.is_a?(Array)
                  resource_or_array.map do |resource|
                    resource.as_jsonapi(options)
                  end
                else
                  resource_or_array.as_jsonapi(options)
                end
        }
      end

      def deserialize(json)
        Array.wrap(json.fetch("data", [])).map do |data|
          klass.new.tap do |resource|
            resource.from_jsonapi(data, options)
          end
        end
      end
    end
  end
end
