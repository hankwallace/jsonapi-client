module JSONAPI
  module Client
    module Attributes

      def attributes
        @attributes
      end

      def attributes=(attrs = {})
        @attributes = attrs.with_indifferent_access
        attrs.each { |key, value| send("#{key}=", value) }
      end

      def [](key)
        get_attribute(key)
      end

      def []=(key, value)
        set_attribute(key, value)
      end

      def method_missing(method_name, *arguments, &block)
        if method_name.to_s =~ /^(.*)=$/
          set_attribute($1, arguments.first)
        elsif has_attribute?(method_name)
          get_attribute(method_name)
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        method_name.to_s =~ /^(.*)=$/ || has_attribute?(method_name) || super
      end

      private

      def has_attribute?(name)
        attributes.has_key?(name)
      end

      def get_attribute(name)
        attributes.fetch(name, nil)
      end

      def set_attribute(name, value)
        attributes[name] = value
      end

    end
  end
end
