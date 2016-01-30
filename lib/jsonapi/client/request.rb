require "jsonapi/client/request_filtering"
require "jsonapi/client/request_sorting"
require "jsonapi/client/request_fields"
require "jsonapi/client/request_pagination"
require "jsonapi/client/request_relationships"
require "jsonapi/client/operation"


# TODO: Blarg! Rename this class. It's really a query builder, not
# a request. All of the non-query methods are directly on a Resource!

module JSONAPI
  module Client
    # module Request
    #   autoload(:Builder, "jsonapi/client/request/builder")
    #   autoload(:Filtering, "jsonapi/client/request/filtering")
    #   autoload(:Sorting, "jsonapi/client/request/sorting")
    #   autoload(:SparseFieldsets, "jsonapi/client/request/sparse_fieldsets")
    #   autoload(:Pagination, "jsonapi/client/request/pagination")
    #   autoload(:Relationships, "jsonapi/client/request/relationships")
    #   autoload(:Sender, "jsonapi/client/request/sender")
    # end

    class Request
      extend Forwardable
      include RequestFiltering
      include RequestSorting
      include RequestFields
      include RequestPagination
      include RequestRelationships

      def_delegators :resource_class, :primary_key, :request_sender

      # attr_reader :resource_class
      attr_accessor :resource_class, :operations

      def initialize(resource_class)
        @resource_class = resource_class
        @operations = []
      end

      def params
        filter_params.
          merge(sort_params).
          merge(fields_params).
          merge(page_params).
          merge(include_params)
      end

      def all
        # request_sender.get(params)
        operations.push(
          JSONAPI::Client::IndexOperation.new(resource_class, params)
        )
        operations_processor.process(operations)
      end
      alias to_a all

      def find(args = {})
        request_sender.get(params.merge(primary_key_params(args)))
      end

      private

      def primary_key_params(args)
        case args
        when Array
          # { primary_key.to_s.pluralize.to_sym => args.join(",") }
          { primary_key => args.join(",") }
        else
          { primary_key => args }
        end
      end

      def operations_processor
        JSONAPI::Client.configuration.operations_processor.new
      end
    end
  end
end
