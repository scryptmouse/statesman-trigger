module Statesman
  module Trigger
    # @api private
    class TriggerQuery < AbstractQuery
      up! <<-SQL
        CREATE TRIGGER %<trigger_name>s AFTER INSERT ON %<transition_table>s
          FOR EACH ROW EXECUTE PROCEDURE %<function_name>s();
      SQL

      down! <<-SQL
        DROP TRIGGER IF EXISTS %<trigger_name>s ON %<transition_table>s;
      SQL
    end
  end
end
