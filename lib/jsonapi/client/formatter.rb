require "active_support"
require "active_support/core_ext/string"

module JSONAPI
  module Client
    class Formatter
      class << self
        def format(arg)
          arg.to_s
        end

        def unformat(arg)
          arg
        end

        def formatter_for(format)
          "JSONAPI::Client::#{format.to_s.camelize}Formatter".safe_constantize
        end
      end
    end

    class KeyFormatter < Formatter
      class << self
        def format(key)
          super
        end

        def unformat(formatted_key)
          super.to_s.underscore
        end
      end
    end

    class RouteFormatter < Formatter
      class << self
        def format(route)
          super
        end

        def format_params(params)
          case params
          when Array
            params.map do |p|
              format_params(p)
            end
          when Hash
            params.map do |k, v|
              { format(k) => format_params(v) }
            end.inject({}, &:merge)
          else
            params
          end
        end

        def unformat(formatted_route)
          super.to_s.underscore
        end
      end
    end

    class ValueFormatter < Formatter
      class << self
        def format(value)
          super
        end

        def unformat(formatted_value)
          super
        end

        def formatter_for(type)
          "#{type.to_s.camelize}ValueFormatter".safe_constantize
        end
      end
    end

    class UnderscoredKeyFormatter < KeyFormatter
      class << self
        def format(key)
          super.underscore
        end

        def unformat(formatted_key)
          super
        end
      end
    end

    class CamelizedKeyFormatter < KeyFormatter
      class << self
        def format(key)
          super.camelize(:lower)
        end

        def unformat(formatted_key)
          super
        end
      end
    end

    class DasherizedKeyFormatter < KeyFormatter
      class << self
        def format(key)
          super.underscore.dasherize
        end

        def unformat(formatted_key)
          super
        end
      end
    end

    class UnderscoredRouteFormatter < RouteFormatter
      class << self
        def format(route)
          super.underscore
        end

        def unformat(formatted_route)
          super
        end
      end
    end

    class CamelizedRouteFormatter < RouteFormatter
      class << self
        def format(route)
          super.camelize(:lower)
        end

        def unformat(formatted_route)
          super
        end
      end
    end

    class DasherizedRouteFormatter < RouteFormatter
      class << self
        def format(route)
          super.dasherize
        end

        def unformat(formatted_route)
          super
        end
      end
    end
  end
end
