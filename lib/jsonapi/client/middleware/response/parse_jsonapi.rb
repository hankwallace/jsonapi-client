# module JSONAPI
#   module Client
#     module Middleware
#       # Response middleware that decodes JSONAPI.
#       class ParseJsonapi < Faraday::Middleware
#
#         # TODO: This class may not be needed. Test to see if the standard
#         # Faraday::Middleware::ParseJson processes the response correctly
#         # WITHOUT overriding the env[:response_headers]['ContentType'].
#
#         define_parser do |body|
#           ::JSON.parse body unless body.strip.empty?
#         end
#
#       end
#     end
#   end
# end