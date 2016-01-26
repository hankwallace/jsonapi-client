module JSONAPI
  module Client
    module RequestSorting
      def order(*args)
        sorts.concat(process_order_args(args))
        self
      end

      def sort_params
        sorts.empty? ? {} : { sort: sorts.join(",") }
      end

      private

      def sorts
        @sorts ||= []
      end

      VALID_DIRECTIONS = [:asc, :desc, :ASC, :DESC,
        "asc", "desc", "ASC", "DESC"]

      def process_order_args(args)
        validate_order_args(args)

        args.map do |arg|
          case arg
          when Hash
            arg.map do |k, v|
              "#{order_operator(v)}#{k}"
            end
          else
            "#{arg}"
          end
        end.flatten
      end

      def validate_order_args(args)
        args.each do |arg|
          next unless arg.is_a?(Hash)
          arg.each do |_, v|
            unless VALID_DIRECTIONS.include?(v)
              raise ArgumentError, "Direction \"#{v}\" is invalid."
            end
          end
        end
      end

      def order_operator(arg)
        if [:desc, :DESC, "desc", "DESC"].include?(arg)
          "-"
        else
          ""
        end
      end
    end
  end
end
