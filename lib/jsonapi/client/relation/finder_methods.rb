module JSONAPI
  module Client
    module FinderMethods
      def find(*args)
        find_with_ids(*args)
      end

      def find_by(arg, *args)
        where(arg, *args).take
      end

      def find_by!(arg, *args)
        find_by(arg, *args) or raise RecordNotFound, "Couldn't find #{@klass.name}"
      end

      def take(limit = nil)
        limit ? limit(limit).to_a : find_take
      end

      def take!
        take or raise RecordNotFound, "Couldn't find #{@klass.name}"
      end

      def first(limit = nil)
        if limit
          find_nth_with_limit(offset_index, limit)
        else
          find_nth(0, offset_index)
        end
      end

      def first!
        find_nth! 0
      end

      def last(limit = nil)
        if limit
          find_last_with_limit(offset_index, limit)
        else
          find_last(0, offset_index)
        end
      end

      def last!
        last or raise RecordNotFound, "Couldn't find #{@klass.name}"
      end

      def second
        find_nth(1, offset_index)
      end

      def second!
        find_nth! 1
      end

      protected

      def find_with_ids(*ids)
        expects_array = ids.first.kind_of?(Array)
        return ids.first if expects_array && ids.first.empty?

        ids = ids.flatten.compact.uniq

        case ids.size
        when 0
          raise RecordNotFound, "Couldn't find #{@klass.name} without an ID"
        when 1
          result = find_one(ids.first)
          expects_array ? [ result ] : result
        else
          find_some(ids)
        end
      end

      def find_one(id)
        operations = [
          JSONAPI::Client::ShowOperation.new(klass, {
            id: id,
            includes: includes_values,
            order: order_values,
            select: select_values,
            where: where_values
          })
        ]
        resource = operations_processor.process(operations).first

        unless resource
          raise RecordNotFound, "Couldn't find #{@klass.name} with '#{primary_key}'=#{id}"
        end

        resource
      end

      def find_some(ids)
        result = where(primary_key => ids).to_a

        expected_size =
          if limit_value && ids.size > limit_value
            limit_value
          else
            ids.size
          end

        # 11 ids with limit 3, offset 9 should give 2 results.
        if offset_value && (ids.size - offset_value < expected_size)
          expected_size = ids.size - offset_value
        end

        if result.size == expected_size
          result
        else
          error = "Couldn't find all #{@klass.name.pluralize} with '#{primary_key}': "
          error << "(#{ids.join(", ")}) (found #{result.size} results, but was looking for #{expected_size})"
          raise RecordNotFound, error
        end
      end

      def find_take
        limit(1).to_a.first
      end

      def find_nth(index, offset)
        offset += index
        find_nth_with_limit(offset, 1).first
      end

      def find_nth!(index)
        find_nth(index, offset_index) or raise RecordNotFound, "Couldn't find #{@klass.name}"
      end

      def find_nth_with_limit(offset, limit)
        relation = if order_values.empty? && primary_key
                     order(primary_key)
                   else
                     self
                   end
        relation = relation.offset(offset) unless offset.zero?
        relation.limit(limit).to_a
      end

      def find_last(index, offset)
        offset += index
        find_last_with_limit(offset, 1).last
      end

      def find_last_with_limit(offset, limit)
        relation = reverse_order
        relation = relation.offset(offset) unless offset.zero?
        relation.limit(limit).to_a
      end

      private

      def offset_index
        offset_value || 0
      end
    end
  end
end
