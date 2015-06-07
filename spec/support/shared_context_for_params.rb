RSpec.shared_context 'params', params: true do
  let (:default_params) { Statesman::Trigger::Parameters.new default_param_options }

  let (:default_param_options) do
    {
      model_klass: Article,
      transition_klass: ArticleTransition
    }
  end
end

RSpec.shared_examples 'expected params' do
  its(:model_table)         { is_expected.to eq 'articles' }
  its(:transition_table)    { is_expected.to eq 'article_transitions' }
  its(:foreign_key_column)  { is_expected.to eq 'article_id' }

  specify '#inspect' do
    expect do
      subject.inspect
    end.to_not raise_error
  end
end
