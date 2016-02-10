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
        response = connection.send(method, route_formatter.format(path), route_formatter.format_params(params))
        serializer.deserialize(response.body || {})
      end
    end

    class QueryOperation < Operation
      attr_reader :includes_values, :order_values, :select_values, :where_values

      def initialize(resource_class, options = {})
        super
        @includes_values = options.fetch(:includes, [])
        @order_values = options.fetch(:order, [])
        @select_values = options.fetch(:select, [])
        @where_values = options.fetch(:where, [])
      end

      def params
        include_param.
          merge(fields_param).
          merge(filter_param).
          merge(sort_param)
      end

      private

      def include_param
        if includes_values.present?
          { include: process_includes_values(includes_values).join(",") }
        else
          {}
        end
      end

      def process_includes_values(values)
        values.map do |value|
          value.to_s.split(",").map(&:strip)
        end
      end

      def fields_param
        if select_values.present?
          { fields: { resource_class.table_name => process_field_values(select_values).join(",") } }
        else
          {}
        end
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

      def filter_param
        where_values.present? ? { filter: filter_value } : {}
      end

      def filter_value
        where_values.reduce({}, &:merge).flat_map do |k, v|
          { k => v.is_a?(Array) ? v.join(",") : v.to_s }
        end.inject({}, &:merge)
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

      def order_operator(arg)
        if [:desc, :DESC, "desc", "DESC"].include?(arg)
          "-"
        else
          ""
        end
      end
    end

    class IndexOperation < QueryOperation
      attr_reader :limit_value, :offset_value

      def initialize(resource_class, options = {})
        super
        @limit_value = options.fetch(:limit, nil)
        @offset_value = options.fetch(:offset, nil)
      end

      def params
        super.
          merge(page_param)
          # merge(sort_param).
          # merge(include_param).
          # merge(page_param)
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

      private

      def page_param
        page = {}
        page.merge!(limit: limit_value) if limit_value
        page.merge!(offset: offset_value) if offset_value
        if page.empty?
          {}
        else
          { page: page }
        end
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
