module JSONAPI
  module Client
    module FinderMethods
      # TODO:

      def find(*args)
        find_with_ids(*args)
      end

      protected

      def find_with_ids(*ids)
        # raise UnknownPrimaryKey.new(@klass) if primary_key.nil?

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
        # relation = where(primary_key => id)
        # record = relation.take
        #
        # raise_record_not_found_exception!(id, 0, 1) unless record
        #
        # record

        operations = [
          JSONAPI::Client::ShowOperation.new(klass, {
            id: id,
            select: select_values
          })
        ]
        resource = operations_processor.process(operations).first

        raise_record_not_found_exception!(id, 0, 1) unless resource

        resource
      end

      def find_some(ids)
        where(primary_key => ids).to_a

        # result = where(primary_key => ids).to_a
        #
        # expected_size =
        #   if limit_value && ids.size > limit_value
        #     limit_value
        #   else
        #     ids.size
        #   end
        #
        # # 11 ids with limit 3, offset 9 should give 2 results.
        # if offset_value && (ids.size - offset_value < expected_size)
        #   expected_size = ids.size - offset_value
        # end
        #
        # if result.size == expected_size
        #   result
        # else
        #   raise_record_not_found_exception!(ids, result.size, expected_size)
        # end
      end


      # This method is called whenever no records are found with either a single
      # id or multiple ids and raises a ActiveRecord::RecordNotFound exception.
      #
      # The error message is different depending on whether a single id or
      # multiple ids are provided. If multiple ids are provided, then the number
      # of results obtained should be provided in the +result_size+ argument and
      # the expected number of results should be provided in the +expected_size+
      # argument.
      def raise_record_not_found_exception!(ids, result_size, expected_size) #:nodoc:
        if Array(ids).size == 1
          error = "Couldn't find #{@klass.name} with '#{primary_key}'=#{ids}"
        else
          error = "Couldn't find all #{@klass.name.pluralize} with '#{primary_key}': "
          error << "(#{ids.join(", ")}) (found #{result_size} results, but was looking for #{expected_size})"
        end

        raise RecordNotFound, error
      end

        # def find(args = {})
      #   request_sender.get(params.merge(primary_key_params(args)))
      # end

    end
  end
end
