# TODO: Move this under JSONAPI::Client::Request?

module JSONAPI
  module Client
    module Middleware
      # Request middleware that encodes the body as JSONAPI.
      class EncodeJsonApi < Faraday::Middleware
        CONTENT_TYPE = "Content-Type".freeze
        MIME_TYPE    = "application/vnd.api+json".freeze

        def call(env)
          env[:request_headers][CONTENT_TYPE] = MIME_TYPE
          env[:request_headers]["Accept"] = MIME_TYPE
          @app.call(env)
        end
      end
    end
  end
end
