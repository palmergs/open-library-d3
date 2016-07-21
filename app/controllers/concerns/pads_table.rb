module Concerns
  module PadsTable
    extend ActiveSupport::Concern

    def pad_table table, query, 
        time_method: :decade, 
        count_method: :count, 
        start: 1220, 
        increment: 10, 
        complete: 2020

      # convert each query into an enumerator;
      # enumerators MUST be ascending by the time_method
      enumerators = query.is_a?(Array) ? query : [ query ]
      enumerators.map!(&:to_enum)

      actual_start = start 
      (start..complete).step(increment) do |n|
        arr = [ n ]
        enumerators.each do |enum|
          begin
            arr << current_value(n, enum, time_method, count_method)
          rescue StopIteration
            arr << 0 # at the end of the enumerator set value to 0
          end
        end
        table << arr
      end
    end

    def current_value current, enum, time_method, count_method
      obj = enum.peek
      year = obj.public_send(time_method)
      count = obj.public_send(count_method)
      if year <= current
        enum.next
        count
      else
        0
      end
    end
  end
end
