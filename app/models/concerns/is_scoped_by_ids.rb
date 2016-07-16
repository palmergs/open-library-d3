module Concerns
  module IsScopedByIds
    extend ActiveSupport::Concern

    included do
      scope :by_ids, ->(ids) {
        if ids
          ids = ids.is_a?(Enumerable) ? ids.map(&:to_i) : [ ids.to_i ]
          ids.count > 0 ? where(id: ids) : none
        end
      }
    end
  end
end
