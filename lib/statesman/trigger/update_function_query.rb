module Statesman
  module Trigger
    # @api private
    class UpdateFunctionQuery < AbstractQuery
      up! <<-SQL
      CREATE OR REPLACE FUNCTION %<function_name>s() RETURNS TRIGGER AS $$
        BEGIN
          UPDATE %<model_table>s SET %<sync_column>s = NEW.to_state WHERE id = NEW.%<foreign_key_column>s;
          RETURN NULL;
        END;
      $$ LANGUAGE plpgsql;
      SQL

      down! <<-SQL
      DROP FUNCTION IF EXISTS %<function_name>s()
      SQL
    end
  end
end
