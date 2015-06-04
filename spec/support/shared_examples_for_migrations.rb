RSpec.shared_context 'migration recording', migrations: true do
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
