class EditionAuthor < ActiveRecord::Base
  belongs_to :edition
  belongs_to :author
end
