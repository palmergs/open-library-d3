class Edition < ActiveRecord::Base
  include Concerns::IsScopedByIds

  has_many :work_editions, dependent: :destroy
  has_many :works, through: :work_editions

  has_many :edition_authors, dependent: :destroy
  has_many :authors, through: :edition_authors

  has_many :external_links, dependent: :destroy, as: :linkable
  has_many :subject_tags, dependent: :destroy, as: :taggable

  scope :by_prefix, ->(q) {
    if q.present?
      sanitized = q.to_s.strip.gsub(/[[:punct]=+$><]/, '')
      where('title like ?', "#{ santitized }%")
    end
  }

  scope :by_year, ->(n) {
    if n.present? && n.to_i > 0
      where(publish_date: n.to_i)
    end
  }
end
