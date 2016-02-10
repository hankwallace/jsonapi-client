module JSONAPI
  module Client
    class Resource

      extend Querying

      # TODO: Why these ActiveModel things?
      # extend ActiveModel::Naming
      # extend ActiveModel::Translation
      # include ActiveModel::Validations
      # include ActiveModel::Conversion
      # include ActiveModel::Serialization

      # include Helpers::DynamicAttributes
      include Attributes
      # include Helpers::Dirty

      # include Associations::BelongsTo
      # include Associations::HasMany
      # include Associations::HasOne

      # attr_accessor :links,
      #               :relationships

      attr_accessor :last_operation_results
        # :links,
        # :relationships

      class_attribute :url,
                      :primary_key,
                      :connection,
                      :connection_class,
                      :connection_options,
                      :serializer_class,
                      :route_format,
                      :route_formatter,
                      :key_format,
                      :key_formatter,
                      :readonly_attributes

      self.primary_key = :id
      self.connection_class = JSONAPI::Client::Connection
      self.connection_options = {}
      self.serializer_class = JSONAPI::Client::Serializer
      self.readonly_attributes = [:id, :type, :links, :meta, :relationships]

      class << self
        def resource_name
          name.demodulize.underscore
        end

        def table_name
          resource_name.pluralize
        end

        def connection
          @connection ||=
            connection_class.new(connection_options.merge(url: url)).tap do |conn|
              yield(conn) if block_given?
            end
        end

        def serializer
          serializer_class.new(self, { key_formatter: key_formatter })
        end

        def path(params = nil)
          components = [table_name]
          File.join(url, *components)
        end

        def route_format=(format)
          @route_format = format
          @route_formatter = JSONAPI::Client::Formatter.formatter_for(format)
        end

        def route_formatter
          @route_formatter ||= JSONAPI::Client.configuration.route_formatter
        end

        def key_format=(format)
          @key_format = format
          @key_formatter = JSONAPI::Client::Formatter.formatter_for(format)
        end

        def key_formatter
          @key_formatter ||= JSONAPI::Client.configuration.key_formatter
        end

        # def load(params)
        #   new(params)
        # end

        # def resource_for(type)
        #   name = JSONAPI::Client::Resource._resource_name_from_type(type)
        #   resource = name.safe_constantize if name
        #   if resource.nil?
        #     fail NameError, "Could not find resource \"#{type}\"."
        #   end
        #
        #   class_name = @@resource_types[type]
        #   if class_name.nil?
        #     class_name = "#{type.to_s.underscore.singularize}_resource".camelize
        #   end
        # end

        # TODO: Any way to include the SpawnMethods, etc here instead of adding these manually?


        # def create(attributes = nil, &block)
        #   new(attributes, &block).tap { |resource| resource.save }
        # end

        protected

        # def has_one(*attrs)
        #   add_relationship(Relationship::ToOne, *attrs)
        # end
        #
        # def has_many(*attrs)
        #   add_relationship(Relationship::ToMany, *attrs)
        # end

        private

        def relation # :nodoc:
          JSONAPI::Client::Relation.new(self)
        end

        # def add_relationship(klass, *attrs)
        #   options = attrs.extract_options!
        #
        # end

      end

      def initialize(attrs = {})
        self.attributes = attrs.merge(type: self.class.table_name)
        @readonly = false
        @destroyed = false
        @new_record = true
        yield self if block_given?
      end


      # def updatable_fields
      #   _updatable_
      # end

      # def new_record?
      #   @new_record
      # end
      #
      # def destroyed?
      #   @destroyed
      # end
      #
      # def persisted?
      #   !(@new_record || @destroyed)
      # end
      #
      # def save
      #   # self.class.request_sender.create(self)
      #   create_or_update
      # end
      #
      # # TODO: From Rails
      # # def update_attribute(name, value)
      # #
      # # end
      #
      # def update(attributes)
      #   assign_attributes(attributes)
      #   save
      # end
      # alias update_attributes update

      # TODO: From Rails: increment, decrement, toggle?

      # TODO: From Rails
      # def reload(options = nil)
      #
      # end

      private

      # def create_or_update(*args)
      #   # raise ReadOnlyRecord, "#{self.class} is marked as readonly" if readonly?
      #   result = new_record? ? _create_resource : _update_resource
      #   result != false
      #
      #   self.last_operation_result = if new_record?
      #                                  _create_resource
      #                                else
      #                                  _update_resource
      #                                end
      #
      #   # if last_result_set.has_errors?
      #   #   last_result_set.errors.each do |error|
      #   #     if error.source_parameter
      #   #       errors.add(error.source_parameter, error.title)
      #   #     else
      #   #       errors.add(:base, error.title)
      #   #     end
      #   #   end
      #   #   false
      #   # else
      #   #   self.errors.clear if self.errors
      #   #   mark_as_persisted!
      #   #   if updated = last_result_set.first
      #   #     self.attributes = updated.attributes
      #   #     self.relationships.attributes = updated.relationships.attributes
      #   #     clear_changes_information
      #   #   end
      #   #   true
      #   # end
      #
      #   if last_operation_result.has_errors?
      #     # TODO:
      #     false
      #   else
      #     # TODO:
      #     true
      #   end
      # end

      # def _create_resource
      #   self.class.request_sender.create(self).tap
      #   @new_record = false
      # end
      #
      # def _update_resource
      #   # TODO:
      # end
    end
  end
end
