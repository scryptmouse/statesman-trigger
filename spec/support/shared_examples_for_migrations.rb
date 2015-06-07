RSpec.shared_context 'migration recording', recording: true do
  let(:recorder) { ActiveRecord::Migration::CommandRecorder.new }

  subject { recorder.commands.first }

  let(:invert) { false }

  before(:each) do
    if invert
      recorder.revert do
        recorder.__send__(action, *migration_args)
      end
    else
      recorder.__send__(action, *migration_args)
    end
  end

  it 'records the correct action' do
    expect(subject.first).to eq action
  end

  context 'when inverting' do
    let(:invert) { true }

    it 'inverts to the correct action' do
      expect(subject.first).to eq opposite_action
    end
  end

  def configured_options
    cmd, args = subject

    Array(args).first
  end
end

RSpec.shared_examples_for 'migration sets state_name', sets_state_name: true do
  it 'sets state_name' do
    expect(configured_options).to include(state_name: test_state_name)
  end
end

RSpec.shared_examples_for 'migration sets model and transition klasses', sets_klasses: true do
  it 'sets klass keys' do
    expect(configured_options).to include(model_klass: Article, transition_klass: ArticleTransition)
  end
end

RSpec.shared_examples_for 'migration sets model and transition tables', sets_tables: true do
  it 'sets tables' do
    expect(configured_options).to include(model_table: 'articles', transition_table: 'article_transitions')
  end
end

RSpec.shared_examples_for 'a working migration' do
  specify 'runs without error' do
    expect do
      run_migration!
    end.to_not raise_error
  end
end

RSpec.shared_examples_for 'a failed migration' do
  specify 'explodes' do
    expect do
      run_migration!
    end.to raise_error Statesman::Trigger::IntrospectionError
  end
end

RSpec.shared_examples_for 'a migration' do |direction, working|
  raise 'invalid direction' unless %i[up down].include?(direction)

  let(:direction) { direction }
  let(:working) { working }

  if metadata[:reversible_migration]
    let(:reversible) { true }
  else
    let(:reversible) { false }
  end

  def run_migration!
    ActiveRecord::Base.transaction(requires_new: true) do
      migration.migrate direction
    end
  end

  if working
    include_examples 'a working migration'
  else
    include_examples 'a failed migration'
  end
end

RSpec.shared_examples_for 'valid migrations', valid_migration: true do
  let(:trigger_name) { tuple.params.trigger_name.gsub('"','') }
  let(:function_name) { tuple.params.function_name.gsub('"','') }

  def function_count_query
    <<-SQL.strip
    SELECT COUNT(*) FROM information_schema.routines WHERE routine_name = '#{function_name}' AND data_type = 'trigger'
    SQL
  end

  def trigger_count_query
    <<-SQL.strip
    SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_name = '#{trigger_name}'
    SQL
  end

  def default_function_count
    connection.select_value(function_count_query).to_i
  end

  def default_trigger_count
    connection.select_value(trigger_count_query).to_i
  end

  def default_function_exists?
    default_function_count > 0
  end

  def default_trigger_exists?
    default_trigger_count > 0
  end

  context 'when migrating up' do
    include_examples 'a migration', :up, true

    it 'creates the trigger' do
      expect { run_migration! }.to change { default_trigger_exists? }.from(false).to(true)
    end

    it 'creates the function' do
      expect { run_migration! }.to change { default_function_exists? }.from(false).to(true)
    end
  end

  context 'when migrating down' do
    include_examples 'a migration', :down, true

    context 'when already migrated up' do
      before(:each) do
        migration.migrate :up
      end

      it 'destroys the trigger' do
        expect { run_migration! }.to change { default_trigger_exists? }.from(true).to(false)
      end

      it 'destroys the function' do
        expect { run_migration! }.to change { default_function_exists? }.from(true).to(false)
      end
    end
  end
end

RSpec.shared_examples_for 'invalid migrations', invalid_migration: true do
  context 'when migrating up' do
    include_examples 'a migration', :up, false
  end

  context 'when migrating down' do
    include_examples 'a migration', :down, false
  end
end
