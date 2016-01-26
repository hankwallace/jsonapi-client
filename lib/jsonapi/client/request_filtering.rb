module JSONAPI
  module Client
    module RequestFiltering
      def where(conditions = {})
        filters.merge!(process_conditions(conditions))
        self
      end

      def filter_params
        filters.empty? ? {} : { filter: filters }
      end

      private

      def filters
        @filters ||= {}
      end

      def process_conditions(conditions)
        conditions.map do |key, value|
          { key => value.is_a?(Array) ? value.join(",") : value.to_s }
        end.inject(&:merge)
      end
    end
  end
end
