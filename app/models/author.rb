class Author < ActiveRecord::Base
  has_many :work_authors, dependent: :destroy
  has_many :authors, through: :work_authors
end
