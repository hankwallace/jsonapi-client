module JSONAPI
  module Client
    module Querying
      delegate :find, :find_by, :find_by!, :take, :take!, to: :relation
      delegate :first, :first!, :last, :last!, :second, :second!, to: :relation
      delegate :includes, :limit, :offset, :order, :where, :select, :all, :to_a, to: :relation
    end
  end
end
