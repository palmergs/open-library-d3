class Author < ActiveRecord::Base
  include Concerns::IsScopedByIds

  self.primary_key = "id"

  has_many :work_authors, dependent: :destroy
  has_many :works, through: :work_authors

  has_many :edition_authors, dependent: :destroy
  has_many :editions, through: :edition_authors

  has_many :external_links, dependent: :destroy, as: :linkable
  has_many :subject_tags, dependent: :destroy, as: :taggable

  scope :by_prefix, ->(q) {
    if q.present?
      sanitized = q.to_s.strip.gsub(/[[:punct]=+$><]/, '')
      where('name like ?', "#{ sanitized }%")
    end
  }

  scope :by_year, ->(year) {
    if year && year.to_i > 0
      where(birth_date: year.to_i)
    end
  }
end
