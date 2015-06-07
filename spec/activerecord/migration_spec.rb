describe ActiveRecord::Migration, params: true do
  each_tuple do |tuple|
    context tuple.description do
      let(:tuple) { tuple }

      context 'in an up / down migration', tuple.migration_options do
        let(:migration) { tuple.test_migration }
      end

      context 'in a reversible migration', reversible_migration: true, **tuple.migration_options do
        let(:migration) { tuple.reversible_migration }
      end
    end
  end
end
