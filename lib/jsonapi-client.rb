require "faraday"
require "faraday_middleware"
require "json"
require "addressable/uri"
require "jsonapi/client/configuration"
require "jsonapi/client/version"

# TODO: or autolaod?
require "jsonapi/client/operation"
# require "jsonapi/client/operation_result"
# require "jsonapi/client/operation_results"

require "jsonapi/client/errors"

module JSONAPI
  module Client
    autoload(:Connection, "jsonapi/client/connection")
    autoload(:Middleware, "jsonapi/client/middleware")

    autoload(:Querying, "jsonapi/client/querying")
    autoload(:Resource, "jsonapi/client/resource")
    autoload(:Serializer, "jsonapi/client/serializer")

    autoload(:Relation, "jsonapi/client/relation")
    autoload(:SpawnMethods, "jsonapi/client/relation/spawn_methods")
    autoload(:QueryMethods, "jsonapi/client/relation/query_methods")
    autoload(:FinderMethods, "jsonapi/client/relation/finder_methods")

    # autoload(:Operation, "jsonapi/client/operation")
    autoload(:OperationResult, "jsonapi/client/operation_result")
    autoload(:OperationResults, "jsonapi/client/operation_results")
    autoload(:OperationsProcessor, "jsonapi/client/operations_processor")
  end
end
