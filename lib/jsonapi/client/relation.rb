# require "jsonapi/client/finder_methods"
# require "jsonapi/client/query_methods"
# require "jsonapi/client/calculations"

module JSONAPI
  module Client
    class Relation
      SINGLE_VALUE_METHODS = [:limit, :offset]
      MULTI_VALUE_METHODS  = [:includes, :select, :order, :where]

      include SpawnMethods, FinderMethods, QueryMethods

      delegate :primary_key, to: :klass

      # http://api.rubyonrails.org/classes/ActiveRecord/Relation.html

      attr_reader :klass

      def initialize(klass, values = {})
        @klass = klass
        @values = values
      end

      def initialize_copy(other)
        # This method is a hot spot, so for now, use Hash[] to dup the hash.
        #   https://bugs.ruby-lang.org/issues/7166
        @values = Hash[@values]
        self
      end

      # class << self
      #
      #   def new(klass, attributes = {})
      #
      #   end
      # end
      #
      # def initialize(*args, &block)
      #
      # end
      #
      # def any?
      #
      # end
      #
      # def blank?
      #
      # end
      #
      # def create(*args, &block)
      #   # TODO: Try to create a new resource with the same scoped
      #   # attributes defined in the relation.
      #   # http://api.rubyonrails.org/classes/ActiveRecord/Relation.html#method-i-create
      # end
      #
      # def create!(*args, &block)
      #
      # end
      #
      # def delete(id_or_array)
      #
      # end
      #
      # def delete_all(conditions = nil)
      #
      # end
      #
      # def destroy(id)
      #
      # end
      #
      # def destroy_all(conditions = nil)
      #
      # end
      #
      # def empty?
      #
      # end
      #
      # def find_or_create_by(attributes, &block)
      #
      # end
      #
      # def find_or_initialize_by(attributes, &block)
      #
      # end
      #
      # def many?
      #
      # end

      def all
        operations = [
          JSONAPI::Client::IndexOperation.new(klass, {
            includes: includes_values,
            limit: limit_value,
            offset: offset_value,
            order: order_values,
            select: select_values,
            where: where_values
          })
        ]
        operations_processor.process(operations)
      end
      alias to_a all

      protected

      def operations_processor
        JSONAPI::Client.configuration.operations_processor.new
      end

    end
  end
end
