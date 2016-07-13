class WorkEdition < ActiveRecord::Base
  belongs_to :work
  belongs_to :edition
end
