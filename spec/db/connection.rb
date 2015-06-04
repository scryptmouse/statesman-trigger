connection_params = { database: 'statesman_trigger_test', adapter: 'postgresql', pool: 5 }

connection_params[:username] = 'postgres' if ENV['TRAVIS'].present?

ActiveRecord::Base.establish_connection connection_params

ActiveRecord::Base.connection.drop_table(:articles, force: :cascade) rescue nil
ActiveRecord::Base.connection.drop_table(:article_transitions, force: :cascade) rescue nil
