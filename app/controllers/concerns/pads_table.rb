module Concerns
  module PadsTable
    extend ActiveSupport::Concern

    def pad_table table, query, 
        time_method: :decade, 
        count_method: :count, 
        start: 1220, 
        increment: 10, 
        complete: 2020

      n = start
      query.each do |entry|
        time = entry.public_send(time_method.to_sym)
        if time >= start
          while n < time
            table << [ n, 0 ]
            n = n + increment
          end
          table << [ time, entry.public_send(count_method.to_sym) ]
          n = time + increment
        end
      end

      while n <= complete
        table << [ n, 0 ]
        n = n + increment
      end
    end
  end
end
