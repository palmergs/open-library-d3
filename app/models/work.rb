class Work < ActiveRecord::Base
  has_many :work_authors, dependent: :destroy
  has_many :authors, through: :work_authors

  has_many :work_editions, dependent: :destroy
  has_many :editions, through: :work_editions

  has_many :external_links, dependent: :destroy, as: :linkable
  has_many :subject_tags, dependent: :destroy, as: :taggable

  scope :by_title_prefix, ->(q) {
    if q.present?
      normalized = q.to_s.strip.gsub(/[[:punct]=+$><]/, '')
      where('title like ?', "#{ normalized }%")
    end
  }

  scope :by_date, ->(n) {
    if n.present? && n.to_i > 0
      where(publish_date: n.to_i)
    end
  }
end
