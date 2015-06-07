module TestMigrations
  BY_NAME = {}

  module AbstractTestMigration
    extend ActiveSupport::Concern
    include ActiveSupport::Configurable

    included do
      config_accessor :tuple
    end
  end

  module Standard
    extend ActiveSupport::Concern
    include AbstractTestMigration

    def up
      create_statesman_trigger *tuple.args
    end

    def down
      drop_statesman_trigger *tuple.args
    end
  end

  module Reversible
    extend ActiveSupport::Concern
    include AbstractTestMigration

    def change
      create_statesman_trigger *tuple.args
    end
  end
end
