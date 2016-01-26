module JSONAPI
  module Client
    class RecordNotFound < StandardError
      attr_reader :resource, :primary_key, :id

      def initialize(message = nil, resource = nil, primary_key = nil, id = nil)
        @primary_key = primary_key
        @resource = resource
        @id = id

        super(message)
      end
    end
  end
end
