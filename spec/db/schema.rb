ActiveRecord::Schema.define do
  self.verbose = false

  create_table :article_transitions, :force => true do |t|
    t.integer :article_id,  null: false
    t.string  :to_state,    null: false

    t.timestamps null: false
  end

  create_table :articles, :force => true do |t|
    t.string :current_state, null: false, default: 'initial'

    t.timestamps null: false
  end
end
