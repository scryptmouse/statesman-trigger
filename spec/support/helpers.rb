module MacroHelper
  def explodes!(method_name, exception_klass = Exception)
    it "##{method_name} raises an error" do
      expect do
        subject.__send__(method_name)
      end.to raise_error exception_klass
    end
  end

  def test_combination!(description, *args, **options)
    context description do
      let(:migration_args) { Array(args) }
      let(:invert_action) { :"invert_#{action}" }

      context 'when creating', migrations: true, **options do
        let(:action) { :create_statesman_trigger }
        let(:opposite_action) { :drop_statesman_trigger }
      end

      context 'when dropping', migrations: true, **options do
        let(:action) { :drop_statesman_trigger }
        let(:opposite_action) { :create_statesman_trigger }
      end

      context 'when inverting'
    end
  end
end

module StaticHelper
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
end

RSpec.configure do |c|
  c.extend MacroHelper
  c.include StaticHelper
  c.extend StaticHelper
end
