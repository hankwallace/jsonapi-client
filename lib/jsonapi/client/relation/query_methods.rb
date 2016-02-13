# require "jsonapi/client/relation"

module JSONAPI
  module Client
    module QueryMethods

      ASCENDING_DIRECTIONS = [:asc, :ASC, "asc", "ASC"]
      DESCENDING_DIRECTIONS = [:desc, :DESC, "desc", "DESC"]
      VALID_DIRECTIONS = ASCENDING_DIRECTIONS + DESCENDING_DIRECTIONS

      Relation::SINGLE_VALUE_METHODS.each do |name|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}_value                   # def offset_value
          @values[:#{name}]                 #   @values[:offset]
        end                                 # end

        def #{name}_value=(value)           # def offset_value=(value)
          @values[:#{name}] = value         #   @values[:offset] = value
        end                                 # end
        CODE
      end

      Relation::MULTI_VALUE_METHODS.each do |name|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}_values                  # def select_values
          @values[:#{name}] || []           #   @values[:select] || []
        end                                 # end
                                            #
        def #{name}_values=(values)         # def select_values=(values)
          @values[:#{name}] = values        #   @values[:select] = values
        end                                 # end
        CODE
      end

      def includes(*args)
        check_if_method_has_arguments!(:includes, args)
        spawn.includes!(*args)
      end

      def includes!(*args) # :nodoc:
        check_if_method_has_arguments!(:includes, args)
        args.reject!(&:blank?)
        args.flatten!
        self.includes_values += args
        self
      end

      def limit(value)
        spawn.limit!(value)
      end

      def limit!(value) # :nodoc:
        self.limit_value = value
        self
      end

      def offset(value)
        spawn.offset!(value)
      end

      def offset!(value)
        self.offset_value = value
        self
      end

      def order(*args)
        spawn.order!(*args)
      end

      def order!(*args) # :nodoc:
        check_if_method_has_arguments!(:order, args)
        validate_order_args(args)
        self.order_values += args
        self
      end

      def reverse_order
        spawn.reverse_order!
      end

      def reverse_order! # :nodoc:
        orders = order_values.uniq
        orders.reject(&:blank?)
        if orders.empty?
          self.order_values = [{ primary_key => :desc }]
        else
          self.order_values = reversed_order_values(orders)
        end
        self
      end

      def select(*args)
        spawn.select!(*args)
      end

      def select!(*args)
        check_if_method_has_arguments!(:select, args)
        args.reject!(&:blank?)
        # validate_select(args)
        self.select_values += args
        self
      end

      def where(*args)
        spawn.where!(*args)
      end

      def where!(*args) # :nodoc:
        check_if_method_has_arguments!(:where, args)
        # self.where_values = args.reduce(&:merge)
        self.where_values += args
        self
      end

      private

      def check_if_method_has_arguments!(method_name, args)
        if args.blank?
          raise ArgumentError, "The method .#{method_name}() must contain arguments."
        end
      end

      def reversed_direction(arg)
        if ASCENDING_DIRECTIONS.include?(arg)
          :desc
        else
          :asc
        end
      end

      def reversed_order_values(values)
        values.map do |value|
          if value.is_a?(Hash)
            value.map do |k, v|
              { k => reversed_direction(v) }
            end.inject({}, &:merge)
          else
            { value => :desc}
          end
        end
      end

      def validate_order_args(args)
        args.each do |arg|
          if arg.is_a?(Hash)
            arg.each do |_, v|
              unless VALID_DIRECTIONS.include?(v)
                raise ArgumentError, "Direction \"#{v}\" is invalid."
              end
            end
          end
        end
      end
    end
  end
end
