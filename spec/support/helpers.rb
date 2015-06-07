require_relative './parameter_tuple'

module MacroHelper
  def explodes!(method_name, exception_klass = Exception)
    it "##{method_name} raises an error" do
      expect do
        subject.__send__(method_name)
      end.to raise_error exception_klass
    end
  end

  def test_recording!(description, *args, **options)
    context description do
      let(:migration_args) { Array(args) }
      let(:invert_action) { :"invert_#{action}" }

      context 'when creating', recording: true, **options do
        let(:action) { :create_statesman_trigger }
        let(:opposite_action) { :drop_statesman_trigger }
      end

      context 'when dropping', recording: true, **options do
        let(:action) { :drop_statesman_trigger }
        let(:opposite_action) { :create_statesman_trigger }
      end
    end
  end
end

module StaticHelper
  TUPLES = []

  module_function

  def connection
    ActiveRecord::Base.connection
  end

  def test_state_name
    'foobar'
  end

  def test_tables
    %w[articles article_transitions]
  end

  def test_klasses
    [Article, ArticleTransition]
  end

  def each_tuple(&block)
    TUPLES.each do |tuple|
      yield tuple if block_given?
    end
  end

  def self.add_tuple(description, *args, **options)
    TUPLES << ParameterTuple.new(description, *args, **options)
  end

  add_tuple 'with just a state_name', test_state_name, sets_state_name: true, valid_migration: false
  add_tuple 'with just two classes', *test_klasses, sets_klasses: true
  add_tuple 'with just two table names', *test_tables, sets_tables: true
  add_tuple 'with state_name and two table names', test_state_name, *test_tables, sets_tables: true, sets_state_name: true
  add_tuple 'with state_name and two classes', test_state_name, *test_klasses, sets_state_name: true, sets_klasses: true
end

RSpec.configure do |c|
  c.extend MacroHelper
  c.include StaticHelper
  c.extend StaticHelper
end
