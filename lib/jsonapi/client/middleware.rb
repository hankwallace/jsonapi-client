module JSONAPI
  module Client
    module Middleware
      extend ActiveSupport::Autoload

      autoload :EncodeJsonApi, "jsonapi/client/middleware/request/encode_json_api"
    end
  end
end
