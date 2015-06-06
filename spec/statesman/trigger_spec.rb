describe Statesman::Trigger, params: true do
  context 'when updating a transition' do
    let (:article) { Article.create! }

    def create_transition_to!(state)
      article.article_transitions.create! to_state: state
    end

    def current_state
      article.reload.current_state
    end

    context 'with no triggers' do
      it 'should not update when changed' do
        expect { create_transition_to! 'foo' }.to_not change { current_state }
      end
    end

    context 'with triggers' do
      before(:each) do
        connection.create_statesman_trigger default_params
      end

      after(:each) do
        connection.drop_statesman_trigger default_params
      end

      it 'should have the new value' do
        expect { create_transition_to! 'foo' }.to change { current_state }.from('initial').to('foo')
      end

      context 'in sequence' do
        it 'should track each value' do
          expect { create_transition_to! 'foo' }.to change { current_state }.from('initial').to('foo')

          expect { create_transition_to! 'bar' }.to change { current_state }.from('foo').to('bar')
        end
      end
    end
  end

  context 'when creating with two classes' do
    it 'works as expected' do
      expect do
        connection.create_statesman_trigger Article, ArticleTransition
      end.to_not raise_error

      expect do
        connection.drop_statesman_trigger Article, ArticleTransition
      end.to_not raise_error
    end
  end

  context 'when providing an invalid sync_column' do
    it 'throws an error' do
      expect do
        connection.create_statesman_trigger default_params.merge(sync_column: 'nonexistent')
      end.to raise_error
    end
  end
end
