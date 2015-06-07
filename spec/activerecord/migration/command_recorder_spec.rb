describe ActiveRecord::Migration::CommandRecorder do
  each_tuple do |tuple|
    test_recording! *tuple.to_recording_test
  end
end
