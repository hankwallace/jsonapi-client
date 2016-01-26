module JSONAPI
  module Client
    module RequestPagination
      def page(number)
        pagination[:number] = number
        self
      end

      def per(size)
        pagination[:size] = size
        self
      end

      def offset(value)
        pagination[:offset] = value
        self
      end

      def limit(value)
        pagination[:limit] = value
        self
      end

      def page_params
        pagination.empty? ? {} : { page: pagination }
      end

      private

      def pagination
        @pagination ||= {}
      end
    end
  end
end
