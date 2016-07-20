module Kaminari
  module PageScopeMethods
    def total_count
      @_hacked_total_count ||= begin
        if self.to_sql =~ /[Ww][Hh][Ee][Rr][Ee]/
          super
        else

          # Special case where no query params are selected
          self.connection.execute("SELECT (reltuples)::integer from pg_class r WHERE relkind='r' AND relname='#{ table_name }'").
                                  first["reltuples"].
                                  to_i
        end
      end
    end
  end
end


Kaminari.configure do |config|
  config.default_per_page = 25
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :p
end


