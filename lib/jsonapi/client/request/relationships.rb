# module JSONAPI
#   module Client
#     module Request
#       module Relationships
#         def includes(*args)
#           relationships.concat(process_includes(args))
#           self
#         end
#
#         def include_params
#           relationships.empty? ? {} : { include: relationships.join(",") }
#         end
#
#         private
#
#         def relationships
#           @relationships ||= []
#         end
#
#         def process_includes(args)
#           args.map do |arg|
#             if arg.is_a?(Array)
#               process_includes(arg)
#             else
#               arg.to_s.split(",").map(&:strip)
#             end
#           end.flatten
#         end
#       end
#     end
#   end
# end
