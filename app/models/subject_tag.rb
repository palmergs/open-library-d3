class SubjectTag < ActiveRecord::Base
  include Concerns::IsScopedByIds

  scope :by_name, ->(c) {
    if c.present?
      where(name: c)
    end
  }

  scope :by_prefix, ->(q) {
    if q.present?
      sanitized = q.to_s.strip.gsub(/[[:punct]=+$><]/, '')
      where('value like ?', "#{ sanitized }%")
    end
  }
end
