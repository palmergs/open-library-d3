class Edition < ActiveRecord::Base
  include Concerns::IsScopedByIds

  has_many :work_editions, dependent: :destroy
  has_many :works, through: :work_editions

  has_many :edition_authors, dependent: :destroy
  has_many :authors, through: :edition_authors

  has_many :external_links, dependent: :destroy, as: :linkable
  has_many :subject_tags, dependent: :destroy, as: :taggable
end
