class Author < ActiveRecord::Base
  has_many :work_authors, dependent: :destroy
  has_many :authors, through: :work_authors

  has_many :external_links, dependent: :destroy, as: :linkable
  has_many :subject_tags, dependent: :destroy, as: :taggable
end
