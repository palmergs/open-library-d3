class WorkAuthor < ActiveRecord::Base
  belongs_to :work
  belongs_to :author
end
