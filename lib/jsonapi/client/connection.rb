module JSONAPI
  module Client
    class Connection
      delegate :get, :post, to: :faraday

      attr_reader :faraday

      def initialize(opts = {})
        url = opts.fetch(:url)
        @faraday = Faraday.new(url) do |conn|
          conn.request :json
          conn.use Middleware::EncodeJsonApi
          conn.use Middleware::Status
          conn.use FaradayMiddleware::ParseJson
          conn.adapter Faraday.default_adapter
        end
        yield(self) if block_given?
      end

      # Middleware is executed in reverse order, so add it before ParseJson
      def use(middleware, *args, &block)
        unless faraday.builder.locked?
          faraday.builder.insert_before(Middleware::ParseJson, middleware, *args, &block)
        end
      end

      def delete(middleware)
        faraday.builder.delete(middleware)
      end
    end
  end
end