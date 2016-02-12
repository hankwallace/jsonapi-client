module JSONAPI
  module Client
    class OperationsProcessor
      # extend Forwardable
      #
      # def_delegators :resource_class, :route_formatter, :connection, :serializer

      # TODO: Use "Result" or "Response"???

      class << self
        def operations_processor_for(operations_processor)
          "#{operations_processor.to_s.camelize}OperationsProcessor".safe_constantize
        end
      end

      def process(operations)
        JSONAPI::Client::OperationResults.new.tap do |results|
          operations.each do |operation|
            result = process_operation(operation)
            results.add_result(result)
          end
        end
      end

      private

      def process_operation(operation)
        operation.apply
      end
    end

  end
end

class BasicOperationsProcessor < JSONAPI::Client::OperationsProcessor; end
