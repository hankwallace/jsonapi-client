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

    class ErrorBase < StandardError
      attr_reader :env

      def initialize(env)
        @env = env
      end

      def status
        env[:status]
      end

      def url
        env[:url]
      end
    end

    class ConnectionError < ErrorBase; end

    class NotAuthorized < ErrorBase; end

    class AccessDenied < ErrorBase; end

    class NotFound < ErrorBase; end

    class UnprocessableEntity < ErrorBase; end

    class BadRequest < ErrorBase; end

    class ServerError < ErrorBase; end

    class UnexpectedStatus < ErrorBase
      def message
        "Unexpected response status #{status} from #{url}"
      end
    end

  end
end
