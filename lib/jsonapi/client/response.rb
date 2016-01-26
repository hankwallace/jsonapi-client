# require "forwardable"

module JSONAPI
  module Client
    # class Response < Array
    #   extend Forwardable
    #
    #   attr_accessor :status,
    #                 :errors,
    #                 :meta,
    #                 :pages,
    #                 :links,
    #                 :implementation,
    #                 :relationships,
    #                 :included
    #
    #   # pagination methods are handled by the paginator
    #   def_delegators :pages, :total_pages, :total_entries, :total_count, :offset, :per_page, :current_page, :limit_value, :next_page, :previous_page, :out_of_bounds?
    #
    #   def has_errors?
    #     errors.present?
    #   end
    # end

    # class Response
    #   attr_reader :operation_results
    #
    #   def initialize(operation_results, options = {})
    #     @operation_results = operation_results
    #     @serializer = options.fetch(:serializer, JSONAPI::Client::Serializer)
    #     @key_formatter = options.fetch(:key_formatter, JSONAPI::Client.configuration.key_formatter)
    #   end
    #
    #   def status
    #     if operation_results.has_errors?
    #       operation_results.all_errors[0].status
    #     else
    #       operation_results.results[0].code
    #     end
    #   end
    # end
  end
end
