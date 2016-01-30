module JSONAPI
  module Client
    class Operation
      extend Forwardable

      def_delegators :resource_class, :primary_key, :connection, :serializer, :route_formatter

      attr_reader :resource_class, :options

      def initialize(resource_class, options = {})
        @resource_class = resource_class
        @options = options
      end

      def apply
      end

      protected

      def path(params)
        if primary_key = params[resource_class.primary_key]
          File.join(resource_class.path(params), encode(primary_key))
        else
          resource_class.path(params)
        end
      end

      def encode(component)
        Addressable::URI.encode_component(component, Addressable::URI::CharacterClasses::UNRESERVED)
      end

      def process(method, path, params)
        response = connection.send(method, route_formatter.format(path), params)
        serializer.deserialize(response.body || {})
      end
    end

    class QueryOperation < Operation
      attr_reader :where_values, :select_values

      def initialize(resource_class, options = {})
        super
        @where_values = options.fetch(:where, [])
        @select_values = options.fetch(:select, [])
      end

      def params
        fields_param.
          merge(filter_param)
      end

      def filter_param
        where_values.present? ? { filter: filter_value } : {}
      end

      def filter_value
        where_values.reduce({}, &:merge).flat_map do |k, v|
          { k => v.is_a?(Array) ? v.join(",") : v.to_s }
        end.inject({}, &:merge)
      end

      def fields_param
        select_values.present? ? { fields: { resource_class.table_name => fields_value } } : {}
      end

      def fields_value
        process_field_values(select_values).join(",")
      end

      def process_field_values(values)
        values.map do |value|
          if value.is_a?(Array)
            process_field_values(value)
          else
            value.to_s.split(",").map(&:strip)
          end
        end.flatten
      end
    end

    class IndexOperation < QueryOperation
      attr_reader :order_values

      def initialize(resource_class, options = {})
        super
        @order_values = options.fetch(:order, [])
      end

      def params
        super.
          merge(sort_param) #.
          # merge(include_param).
          # merge(page_param)
      end

      def sort_param
        order_values.present? ? { sort: sort_value } : {}
      end

      def sort_value
        order_values.map do |arg|
          case arg
          when Hash
            arg.map do |k, v|
              "#{order_operator(v)}#{k}"
            end
          else
            "#{arg}"
          end
        end.flatten.join(",")
      end

      def apply
        process(:get, path(params), params.except(resource_class.primary_key))

        # return JSONAPI::ResourcesOperationResult.new(:ok,
        #   resource_records,
        #   options)

      # rescue => e
      # # rescue JSONAPI::Exceptions::Error => e
      #   return JSONAPI::ErrorsOperationResult.new(e.errors[0].code, e.errors)
      end
    end

    class ShowOperation < QueryOperation
      attr_reader :id

      def initialize(resource_class, options = {})
        super
        @id = options[:id]
      end

      def params
        { id: id }.
          merge(super)
      end

      def apply
        process(:get, path(params), params.except(primary_key))

        # return JSONAPI::ResourceOperationResult.new(:ok, resource_record)

      # rescue JSONAPI::Exceptions::Error => e
      #   return JSONAPI::ErrorsOperationResult.new(e.errors[0].code, e.errors)
      end
    end

    # class CreateOperation < Operation
    #   attr_reader :data
    #
    #   def initialize(resource_class, options = {})
    #     super(resource_class, options)
    #     @data = options.fetch(:data)
    #   end
    #
    #   def apply
    #     resource = @resource_class.create(@context)
    #     result = resource.replace_fields(@data)
    #
    #     return JSONAPI::ResourceOperationResult.new((result == :completed ? :created : :accepted), resource)
    #
    #   rescue JSONAPI::Exceptions::Error => e
    #     return JSONAPI::ErrorsOperationResult.new(e.errors[0].code, e.errors)
    #   end
    # end
    #
    # class RemoveOperation < Operation
    #   attr_reader :resource_id
    #   def initialize(resource_class, options = {})
    #     super(resource_class, options)
    #     @resource_id = options.fetch(:resource_id)
    #   end
    #
    #   def apply
    #     resource = @resource_class.find_by_key(@resource_id, context: @context)
    #     result = resource.remove
    #
    #     return JSONAPI::OperationResult.new(result == :completed ? :no_content : :accepted)
    #
    #   rescue JSONAPI::Exceptions::Error => e
    #     return JSONAPI::ErrorsOperationResult.new(e.errors[0].code, e.errors)
    #   end
    # end
    #
    # class ReplaceFieldsOperation < Operation
    #   attr_reader :data, :resource_id
    #
    #   def initialize(resource_class, options = {})
    #     super(resource_class, options)
    #     @resource_id = options.fetch(:resource_id)
    #     @data = options.fetch(:data)
    #   end
    #
    #   def apply
    #     resource = @resource_class.find_by_key(@resource_id, context: @context)
    #     result = resource.replace_fields(data)
    #
    #     return JSONAPI::ResourceOperationResult.new(result == :completed ? :ok : :accepted, resource)
    #   end
    # end
  end
end
