class SubjectTag < ActiveRecord::Base
  include Concerns::IsScopedByIds
  include Concerns::IsScopedByLike

  scope :by_name, ->(c) {
    if c.present?
      where(name: c)
    end
  }

  scope :by_prefix, ->(q) {
    if q.present?
      where('value like ?', "#{ sanitized_for_like(q) }%")
    end
  }
end
