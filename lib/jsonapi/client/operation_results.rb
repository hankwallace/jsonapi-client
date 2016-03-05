module JSONAPI
  module Client
    class OperationResults
      include Enumerable

      attr_accessor :errors, :meta, :links

      def initialize
        @results = []
        @resources = []
        @has_errors = false
        @meta = {}
        @links = {}
      end

      def add_result(result)
        @has_errors = true if result.is_a?(JSONAPI::Client::ErrorsOperationResult)
        @results.push(result)
        @resources.concat(result.resources) if result.respond_to?(:resources)
      end

      def has_errors?
        @has_errors
      end

      def all_errors
        errors = []
        if @has_errors
          @results.each do |result|
            if result.is_a?(JSONAPI::Client::ErrorsOperationResult)
              errors.concat(result.errors)
            end
          end
        end
        errors
      end

      def status
        if has_errors?
          all_errors.first.status
        else
          @results.first.status
        end
      end

      def length
        @resources.length
      end
      alias :size :length

      def each
        if block_given?
          @resources.each { |row| yield row }
        else
          @resources.to_enum { resources.size }
        end
      end

      alias :map! :map
      alias :collect! :map

      def empty?
        @resources.empty?
      end

      def [](idx)
        @resources[idx]
      end

      def first
        @resources.first
      end

      def last
        @resources.last
      end

      # def concat(other_ary)
      #   resources.concat(other_ary)
      # end

      # def initialize_copy(other)
      #   @resources = resources.dup
      # end
    end
  end
end
