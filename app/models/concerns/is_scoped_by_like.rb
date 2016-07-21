module Concerns
  module IsScopedByLike
    extend ActiveSupport::Concern

    class_methods do
      def sanitized_for_like str
        pattern = Regexp.union('\\', '%', '_')
        str.gsub(pattern) {|x| [ '\\', x ].join } 
      end
    end
  end
end

