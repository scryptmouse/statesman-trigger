describe ActiveRecord::Migration::CommandRecorder do
  test_combination! 'with two classes', *test_klasses, sets_klasses: true
  test_combination! 'with just a state_name', test_state_name, sets_state_name: true
  test_combination! 'with two table names', *test_tables, sets_tables: true
  test_combination! 'with state_name and two table names', test_state_name, *test_tables, sets_tables: true, sets_state_name: true
  test_combination! 'with state_name and two classes', test_state_name, *test_klasses, sets_state_name: true, sets_klasses: true
end
