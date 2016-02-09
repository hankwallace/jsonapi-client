# require "active_support"
# require "active_support/core_ext/hash"
#
# # TODO: Migrate to OperationsProcessor
#
# module JSONAPI
#   module Client
#     class RequestSender
#       extend Forwardable
#
#       def_delegators :resource_class, :route_formatter, :connection, :serializer
#
#       attr_reader :resource_class
#
#       def initialize(resource_class)
#         @resource_class = resource_class
#       end
#
#       def get(params = {})
#         request(:get, path(params), params.except(resource_class.primary_key))
#       end
#
#       def create(resource)
#         request(:post, resource_class.path, serializer.serialize(resource))
#       end
#
#       def update(resource)
#         request(:patch, path(resource.attributes), { data: resource.as_jsonapi })
#       end
#
#       def destroy(resource)
#         request(:delete, path(resource.attributes), {})
#       end
#
#       protected
#
#       def path(params)
#         if resource_id = params[resource_class.primary_key]
#           File.join(resource_class.path(params), encode(resource_id))
#         else
#           resource_class.path(params)
#         end
#       end
#
#       def encode(component)
#         Addressable::URI.encode_component(component, Addressable::URI::CharacterClasses::UNRESERVED)
#       end
#
#       def request(method, path, params)
#         response = connection.send(method, route_formatter.format(path), params)
#         serializer.deserialize(response.body || {})
#       end
#     end
#   end
# end
