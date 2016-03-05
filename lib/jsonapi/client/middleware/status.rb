module JSONAPI
  module Client
    module Middleware
      class Status < Faraday::Middleware
        def call(env)
          @app.call(env).on_complete do |env|
            process_status(env[:status], env)
          end
        rescue Faraday::ConnectionFailed, Faraday::TimeoutError
          raise ConnectionError, env
        end

        protected

        def process_status(status, env)
          case status
          when 200..399
          when 401
            raise NotAuthorized, env
          when 403
            raise AccessDenied, env
          when 404
            raise NotFound, env
          when 422
            raise UnprocessableEntity, env
          when 400..499
            raise BadRequest, env
          when 500..599
            raise ServerError, env
          else
            raise UnexpectedStatus, env
          end
        end
      end
    end
  end
end