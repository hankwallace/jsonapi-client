module JSONAPI
  module Client
    class OperationResult
      attr_accessor :status, :options, :meta, :links

      def initialize(status, options = {})
        @status = status
        @options = options
        @meta = options.fetch(:meta, {})
        @links = options.fetch(:links, {})
      end
    end

    class ErrorsOperationResult < OperationResult
      attr_accessor :errors

      def initialize(status, errors, options = {})
        super(status, options)
        @errors = errors
      end
    end

    # class ResourceOperationResult < OperationResult
    #   attr_accessor :resource
    #
    #   def initialize(code, resource, options = {})
    #     @resource = resource
    #     super(code, options)
    #   end
    # end

    class ResourcesOperationResult < OperationResult
      attr_accessor :resources

      def initialize(status, resources, options = {})
        super(status, options)
        @resources = resources
      end
    end

    # class RelatedResourcesOperationResult < ResourcesOperationResult
    #   attr_accessor :source_resource, :_type
    #
    #   def initialize(code, source_resource, type, resources, options = {})
    #     @source_resource = source_resource
    #     @_type = type
    #     super(code, resources, options)
    #   end
    # end

    # class LinksObjectOperationResult < OperationResult
    #   attr_accessor :parent_resource, :relationship
    #
    #   def initialize(code, parent_resource, relationship, options = {})
    #     @parent_resource = parent_resource
    #     @relationship = relationship
    #     super(code, options)
    #   end
    # end
  end
end
