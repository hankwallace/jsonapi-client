require "active_support/callbacks"

module JSONAPI
  module Client
    module Callbacks
      def self.included(base)
        base.class_eval do
          include ActiveSupport::Callbacks
          base.extend ClassMethods
        end
      end

      module ClassMethods

      end
    end
  end
end
