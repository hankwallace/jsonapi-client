module JSONAPI
  module Client
    module Querying
      delegate :find, to: :relation
      delegate :includes, :limit, :offset, :order, :where, :select, :all, to: :relation
    end
  end
end
