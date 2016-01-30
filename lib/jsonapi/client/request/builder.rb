# module JSONAPI
#   module Client
#     module Request
#       class Builder
#         extend Forwardable
#         include Filtering
#         include Sorting
#         include Pagination
#         include Relationships
#
#         def_delegators :resource_class, :primary_key, :request_sender
#
#         attr_reader :resource_class
#
#         def initialize(resource_class)
#           @resource_class = resource_class
#         end
#
#         def params
#           filter_params.
#             merge(sort_params).
#             merge(fields_params).
#             merge(page_params).
#             merge(include_params)
#         end
#
#         def all
#           request_sender.get(params)
#         end
#         alias to_a all
#
#         def find(args = {})
#           request_sender.get(params.merge(primary_key_params(args)))
#         end
#
#         private
#
#         def primary_key_params(args)
#           case args
#           when Array
#             # { primary_key.to_s.pluralize.to_sym => args.join(",") }
#             { primary_key => args.join(",") }
#           else
#             { primary_key => args }
#           end
#         end
#       end
#     end
#   end
# end
