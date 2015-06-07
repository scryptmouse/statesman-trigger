describe Statesman::Trigger::Parameters, params: true do
  subject { described_class.new options }

  context 'with valid model_klass and transition_klass' do
    let (:options) { default_param_options }

    include_examples 'expected params'
  end

  context 'when not provided classes' do
    context 'and provided tables' do
      let :options do
        {
          model_table:        :articles,
          transition_table:   :article_transitions
        }
      end

      include_examples 'expected params'
    end

    context 'and not provided tables' do
      let(:options) { Hash.new }

      explodes! :model_table, Statesman::Trigger::IntrospectionError
      explodes! :transition_table, Statesman::Trigger::IntrospectionError
      explodes! :foreign_key_column, Statesman::Trigger::IntrospectionError
    end
  end
end
