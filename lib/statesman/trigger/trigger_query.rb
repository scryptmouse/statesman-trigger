module Statesman
  module Trigger
    # Generates `[ CREATE | DROP ] TRIGGER` statements.
    #
    # @api private
    class TriggerQuery < AbstractQuery
      up! <<-SQL
        CREATE TRIGGER %<quoted_trigger_name>s AFTER INSERT ON %<transition_table>s
          FOR EACH ROW EXECUTE PROCEDURE %<quoted_function_name>s();
      SQL

      down! <<-SQL
        DROP TRIGGER IF EXISTS %<quoted_trigger_name>s ON %<transition_table>s;
      SQL
    end
  end
end
