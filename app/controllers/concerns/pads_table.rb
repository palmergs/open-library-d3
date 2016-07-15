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

      (start..complete).step(increment) do |n|
        arr = [ n ]
        enumerators.each do |enum|
          begin
            obj, key, val = advance_until(enum, n, time_method, count_method)
            arr << (key == n ? val : 0)
          rescue StopIteration
            arr << 0 # at the end of the enumerator set value to 0
          end
        end

        table << arr
      end
    end

    def advance_until enum, n, time_method, count_method
      while true
        obj = enum.peek
        key = obj.public_send(time_method)
        return [ obj, key, obj.public_send(count_method) ] if key >= n

        enum.next
      end
    end
  end
end
