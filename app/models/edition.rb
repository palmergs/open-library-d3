class Edition < ActiveRecord::Base
  belongs_to :work, counter_cache: true
end
