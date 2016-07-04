class Edition < ActiveRecord::Base
  belongs_to :work, counter_cache: true

  has_many :external_links, dependent: :destroy, as: :linkable
  has_many :subject_tags, dependent: :destroy, as: :taggable
end
