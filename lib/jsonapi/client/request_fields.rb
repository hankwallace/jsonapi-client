module JSONAPI
  module Client
    module RequestFields
      def select(*args)
        fields.concat(process_fields(args))
        self
      end

      def fields_params
        fields.empty? ? {} : { fields: { resource_class.table_name => fields.join(",") } }
      end

      private

      def fields
        @fields ||= []
      end

      def process_fields(args)
        args.map do |arg|
          if arg.is_a?(Array)
            process_fields(arg)
          else
            arg.to_s.split(",").map(&:strip)
          end
        end.flatten
      end
    end
  end
end
