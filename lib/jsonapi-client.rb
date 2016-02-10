require "faraday"
require "faraday_middleware"
require "json"
require "addressable/uri"
require "active_model"
require "active_support/all"
require "jsonapi/client/version"
require "jsonapi/client/configuration"

module JSONAPI
  module Client
    extend ActiveSupport::Autoload

    # eager_autoload do
    #   autoload :Formatter
    #   autoload :OperationsProcessor
    #   autoload :Configuration
    # end

    autoload :Connection
    autoload :Querying
    autoload :Attributes
    autoload :Resource
    autoload :Serializer
    autoload :Formatter
    autoload :Relation

    autoload_under "relation" do
      autoload :SpawnMethods
      autoload :QueryMethods
      autoload :FinderMethods
    end

    autoload :Operation
    autoload :IndexOperation, "jsonapi/client/operation"
    autoload :ShowOperation, "jsonapi/client/operation"

    autoload :OperationResult
    autoload :OperationResults
    autoload :OperationsProcessor

    autoload :RecordNotFound, "jsonapi/client/errors"

    module Middleware
      extend ActiveSupport::Autoload

      autoload :EncodeJsonApi
    end
  end
end
