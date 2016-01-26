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
      attr_reader :select_values

      def initialize(resource_class, options = {})
        super
        @select_values = options.fetch(:select, [])
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

    class FindOperation < QueryOperation
      # attr_reader :filters, :include_directives, :sort_criteria, :paginator
      attr_reader :where_values, :order_values

      def initialize(resource_class, options = {})
        super
        @where_values = options[:where]
        @order_values = options.fetch(:order, [])
      end

      def params
        filter_param.
          merge(sort_param).
          merge(fields_param)
          # merge(page_params).
          # merge(include_params)
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
      # attr_reader :id, :include_directives
      attr_reader :id, :select_values

      def initialize(resource_class, options = {})
        super
        @id = options.fetch(:id)
      end

      def params
        # TODO:
        { id: id }.
          merge(fields_param)
      end

      def apply
        # key = @resource_class.verify_key(@id, @context)
        #
        # resource_record = @resource_class.find_by_key(key,
        #   context: @context,
        #   include_directives: @include_directives)

        process(:get, path(params), params.except(primary_key))

        # return JSONAPI::ResourceOperationResult.new(:ok, resource_record)

      # rescue JSONAPI::Exceptions::Error => e
      #   return JSONAPI::ErrorsOperationResult.new(e.errors[0].code, e.errors)
      end
    end

    # class ShowRelationshipOperation < Operation
    #   attr_reader :parent_key, :relationship_type
    #
    #   def initialize(resource_class, options = {})
    #     super(resource_class, options)
    #     @parent_key = options.fetch(:parent_key)
    #     @relationship_type = options.fetch(:relationship_type)
    #   end
    #
    #   def apply
    #     parent_resource = resource_class.find_by_key(@parent_key, context: @context)
    #
    #     return JSONAPI::LinksObjectOperationResult.new(:ok,
    #       parent_resource,
    #       resource_class._relationship(@relationship_type))
    #
    #   rescue JSONAPI::Exceptions::Error => e
    #     return JSONAPI::ErrorsOperationResult.new(e.errors[0].code, e.errors)
    #   end
    # end
    #
    # class ShowRelatedResourceOperation < Operation
    #   attr_reader :source_class, :source_id, :relationship_type
    #
    #   def initialize(resource_class, options = {})
    #     super(resource_class, options)
    #     @source_class = options.fetch(:source_class)
    #     @source_id = options.fetch(:source_id)
    #     @relationship_type = options.fetch(:relationship_type)
    #   end
    #
    #   def apply
    #     source_resource = @source_class.find_by_key(@source_id, context: @context)
    #
    #     related_resource = source_resource.public_send(@relationship_type)
    #
    #     return JSONAPI::ResourceOperationResult.new(:ok, related_resource)
    #
    #   rescue JSONAPI::Exceptions::Error => e
    #     return JSONAPI::ErrorsOperationResult.new(e.errors[0].code, e.errors)
    #   end
    # end
    #
    # class ShowRelatedResourcesOperation < Operation
    #   attr_reader :source_class, :source_id, :relationship_type, :filters, :sort_criteria, :paginator
    #
    #   def initialize(resource_class, options = {})
    #     super(resource_class, options)
    #     @source_class = options.fetch(:source_class)
    #     @source_id = options.fetch(:source_id)
    #     @relationship_type = options.fetch(:relationship_type)
    #     @filters = options[:filters]
    #     @sort_criteria = options[:sort_criteria]
    #     @paginator = options[:paginator]
    #   end
    #
    #   def record_count
    #     @_record_count ||= records.count(:all)
    #   end
    #
    #   def source_resource
    #     @_source_resource ||= @source_class.find_by_key(@source_id, context: @context)
    #   end
    #
    #   def records
    #     related_resource_records = source_resource.public_send("records_for_" + @relationship_type)
    #     @resource_class.filter_records(@filters, @options, related_resource_records)
    #   end
    #
    #   def pagination_params
    #     if @paginator && JSONAPI.configuration.top_level_links_include_pagination
    #       options = {}
    #       options[:record_count] = record_count if @paginator.class.requires_record_count
    #       @paginator.links_page_params(options)
    #     else
    #       {}
    #     end
    #   end
    #
    #   def options
    #     opts = {}
    #     opts.merge!(pagination_params: pagination_params) if JSONAPI.configuration.top_level_links_include_pagination
    #     opts.merge!(record_count: record_count) if JSONAPI.configuration.top_level_meta_include_record_count
    #     opts
    #   end
    #
    #   def apply
    #     related_resource = source_resource.public_send(@relationship_type,
    #       filters:  @filters,
    #       sort_criteria: @sort_criteria,
    #       paginator: @paginator)
    #
    #     return JSONAPI::RelatedResourcesOperationResult.new(:ok, source_resource, @relationship_type, related_resource, options)
    #
    #   rescue JSONAPI::Exceptions::Error => e
    #     return JSONAPI::ErrorsOperationResult.new(e.errors[0].code, e.errors)
    #   end
    # end
    #
    # class CreateResourceOperation < Operation
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
    # class RemoveResourceOperation < Operation
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
    #
    # class ReplaceToOneRelationshipOperation < Operation
    #   attr_reader :resource_id, :relationship_type, :key_value
    #
    #   def initialize(resource_class, options = {})
    #     super(resource_class, options)
    #     @resource_id = options.fetch(:resource_id)
    #     @key_value = options.fetch(:key_value)
    #     @relationship_type = options.fetch(:relationship_type).to_sym
    #   end
    #
    #   def apply
    #     resource = @resource_class.find_by_key(@resource_id, context: @context)
    #     result = resource.replace_to_one_link(@relationship_type, @key_value)
    #
    #     return JSONAPI::OperationResult.new(result == :completed ? :no_content : :accepted)
    #   end
    # end
    #
    # class ReplacePolymorphicToOneRelationshipOperation < Operation
    #   attr_reader :resource_id, :relationship_type, :key_value, :key_type
    #
    #   def initialize(resource_class, options = {})
    #     super(resource_class, options)
    #     @resource_id = options.fetch(:resource_id)
    #     @key_value = options.fetch(:key_value)
    #     @key_type = options.fetch(:key_type)
    #     @relationship_type = options.fetch(:relationship_type).to_sym
    #   end
    #
    #   def apply
    #     resource = @resource_class.find_by_key(@resource_id, context: @context)
    #     result = resource.replace_polymorphic_to_one_link(@relationship_type, @key_value, @key_type)
    #
    #     return JSONAPI::OperationResult.new(result == :completed ? :no_content : :accepted)
    #   end
    # end
    #
    # class CreateToManyRelationshipOperation < Operation
    #   attr_reader :resource_id, :relationship_type, :data
    #
    #   def initialize(resource_class, options)
    #     super(resource_class, options)
    #     @resource_id = options.fetch(:resource_id)
    #     @data = options.fetch(:data)
    #     @relationship_type = options.fetch(:relationship_type).to_sym
    #   end
    #
    #   def apply
    #     resource = @resource_class.find_by_key(@resource_id, context: @context)
    #     result = resource.create_to_many_links(@relationship_type, @data)
    #
    #     return JSONAPI::OperationResult.new(result == :completed ? :no_content : :accepted)
    #   end
    # end
    #
    # class ReplaceToManyRelationshipOperation < Operation
    #   attr_reader :resource_id, :relationship_type, :data
    #
    #   def initialize(resource_class, options)
    #     super(resource_class, options)
    #     @resource_id = options.fetch(:resource_id)
    #     @data = options.fetch(:data)
    #     @relationship_type = options.fetch(:relationship_type).to_sym
    #   end
    #
    #   def apply
    #     resource = @resource_class.find_by_key(@resource_id, context: @context)
    #     result = resource.replace_to_many_links(@relationship_type, @data)
    #
    #     return JSONAPI::OperationResult.new(result == :completed ? :no_content : :accepted)
    #   end
    # end
    #
    # class RemoveToManyRelationshipOperation < Operation
    #   attr_reader :resource_id, :relationship_type, :associated_key
    #
    #   def initialize(resource_class, options)
    #     super(resource_class, options)
    #     @resource_id = options.fetch(:resource_id)
    #     @associated_key = options.fetch(:associated_key)
    #     @relationship_type = options.fetch(:relationship_type).to_sym
    #   end
    #
    #   def apply
    #     resource = @resource_class.find_by_key(@resource_id, context: @context)
    #     result = resource.remove_to_many_link(@relationship_type, @associated_key)
    #
    #     return JSONAPI::OperationResult.new(result == :completed ? :no_content : :accepted)
    #   end
    # end
    #
    # class RemoveToOneRelationshipOperation < Operation
    #   attr_reader :resource_id, :relationship_type
    #
    #   def initialize(resource_class, options)
    #     super(resource_class, options)
    #     @resource_id = options.fetch(:resource_id)
    #     @relationship_type = options.fetch(:relationship_type).to_sym
    #   end
    #
    #   def apply
    #     resource = @resource_class.find_by_key(@resource_id, context: @context)
    #     result = resource.remove_to_one_link(@relationship_type)
    #
    #     return JSONAPI::OperationResult.new(result == :completed ? :no_content : :accepted)
    #   end
    # end
  end
end
