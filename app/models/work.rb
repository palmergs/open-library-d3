class Work < ActiveRecord::Base
  has_many :work_authors, dependent: :destroy
  has_many :authors, through: :work_authors

  has_many :editions
end
