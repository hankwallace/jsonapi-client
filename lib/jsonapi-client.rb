require "faraday"
require "faraday_middleware"
require "json"
require "addressable/uri"
require "active_model"
require "active_support/all"
require "jsonapi/client/version"
require "jsonapi/client/configuration"
require "jsonapi/client/errors"

module JSONAPI
  module Client
    extend ActiveSupport::Autoload

    autoload :Connection
    autoload :Resource
    autoload :Serializer
    autoload :Formatter
    autoload :Relation

    autoload_under "relation" do
      autoload :SpawnMethods
      autoload :QueryMethods
      autoload :FinderMethods
    end

    autoload_under "resource" do
      autoload :Querying
      autoload :Attributes
      autoload :Serialization
    end

    autoload :Operation
    autoload :IndexOperation, "jsonapi/client/operation"
    autoload :ShowOperation, "jsonapi/client/operation"

    autoload :OperationResult
    autoload :ErrorsOperationResult, "jsonapi/client/operation_result"
    autoload :ResourcesOperationResult, "jsonapi/client/operation_result"

    autoload :OperationResults
    autoload :OperationsProcessor

    module Middleware
      extend ActiveSupport::Autoload

      autoload :EncodeJsonApi
      autoload :Status
    end
  end
end
