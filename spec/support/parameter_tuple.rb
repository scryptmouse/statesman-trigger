require_relative './test_migrations'

class ParameterTuple
  attr_reader :description, :args, :sets_klasses, :sets_state_name, :sets_tables, :klass_name, :migration_name, :reversible_migration_name
  attr_reader :valid_migration

  include Statesman::Trigger::Integration::SharedMethods

  def initialize(description, *args, valid_migration: true, sets_tables: false, sets_klasses: false, sets_state_name: false)
    @description  = description
    @args         = Array(args)

    @klass_name     = description.gsub(/\s/, '_').camelize
    @migration_name = klass_name.to_sym
    @reversible_migration_name = :"Reversible#{klass_name}"

    @sets_klasses     = sets_klasses
    @sets_tables      = sets_tables
    @sets_state_name  = sets_state_name
    @valid_migration  = valid_migration
  end

  def params
    @params ||= build_statesman_trigger_params args
  end

  def migration_options
    {}.tap do |options|
      if valid_migration
        options[:valid_migration] = true
      else
        options[:invalid_migration] = true
      end
    end
  end

  def test_migration
    TestMigrations::BY_NAME[description] ||= build_test_migration
  end

  def reversible_migration
    TestMigrations::BY_NAME["reversible #{description}"] ||= build_reversible_migration
  end

  def to_recording_test
    [description, *args, recording_options]
  end

  def recording_options
    {}.tap do |options|
      options[:sets_klasses]    = true if sets_klasses
      options[:sets_state_name] = true if sets_state_name
      options[:sets_tables]     = true if sets_tables
    end
  end

  protected

  def build_reversible_migration
    TestMigrations.const_set(reversible_migration_name, Class.new(ActiveRecord::Migration)).tap do |klass|
      klass.include TestMigrations::Reversible
      klass.tuple = self
    end
  end

  def build_test_migration
    TestMigrations.const_set(migration_name, Class.new(ActiveRecord::Migration)).tap do |klass|
      klass.include TestMigrations::Standard
      klass.tuple = self
    end
  end
end
