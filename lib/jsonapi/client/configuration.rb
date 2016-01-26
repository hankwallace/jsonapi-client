require "jsonapi/client/formatter"
require "jsonapi/client/operations_processor"

module JSONAPI
  module Client
    class Configuration
      attr_reader :key_format,
                  :key_formatter,
                  :route_format,
                  :route_formatter,
                  :operations_processor

      def initialize
        # :underscored_route, :camelized_route, :dasherized_route, or custom
        self.route_format = :dasherized_route

        # :underscored_key, :camelized_key, :dasherized_key, or custom
        self.key_format = :dasherized_key

        # :basic or custom
        self.operations_processor = :basic
      end

      def route_format=(format)
        @route_format = format
        @route_formatter = JSONAPI::Client::Formatter.formatter_for(format)
      end

      def route_formatter
        @route_formatter = JSONAPI::Client::Formatter.formatter_for(route_format)
      end

      def key_format=(format)
        @key_format = format
        @key_formatter = JSONAPI::Client::Formatter.formatter_for(format)
      end

      def key_formatter
        @key_formatter = JSONAPI::Client::Formatter.formatter_for(key_format)
      end

      def operations_processor=(operations_processor)
        @operations_processor =
          JSONAPI::Client::OperationsProcessor.operations_processor_for(operations_processor)
      end
    end

    class << self
      attr_accessor :configuration
    end

    @configuration ||= Configuration.new

    def self.configure
      yield(@configuration)
    end
  end
end
