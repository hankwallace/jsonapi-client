require "faraday"
require "faraday_middleware"
require "json"
require "addressable/uri"
require "jsonapi/client/configuration"
require "jsonapi/client/version"

# TODO: or autolaod?
# require "jsonapi/client/operations_processor"
require "jsonapi/client/operation_result"
require "jsonapi/client/operation_results"

require "jsonapi/client/errors"

module JSONAPI
  module Client
    autoload(:Connection, "jsonapi/client/connection")
    autoload(:Middleware, "jsonapi/client/middleware")
    autoload(:Request, "jsonapi/client/request")
    # autoload(:Response, "jsonapi/client/response")
    autoload(:Resource, "jsonapi/client/resource")
    autoload(:Serializer, "jsonapi/client/serializer")

    autoload(:Relation, "jsonapi/client/relation")
    autoload(:SpawnMethods, "jsonapi/client/spawn_methods")
    autoload(:QueryMethods, "jsonapi/client/query_methods")
    autoload(:FinderMethods, "jsonapi/client/finder_methods")

    autoload(:OperationsProcessor, "jsonapi/client/operations_processor")
  end
end
