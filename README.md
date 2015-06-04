# Statesman::Trigger

This is an extension to the fantastic [Statesman gem](https://github.com/gocardless/statesman)
to create a database trigger to keep the most recent transition in sync on a specific column
on the parent model.

Presently, it is only designed to work with PostgreSQL.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'statesman-trigger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install statesman-trigger

## Usage

Usage in a rails migration is straightforward, assuming you use the defaults:

```ruby
def change
  add_column :orders, :current_state, :string, null: false, default: 'pending', index: true

  create_statesman_trigger Order, OrderTransition
end
```

The migration script will introspect from the provided classes.

If you want your column to be named something else:

```ruby
def change
  add_column :orders, :anything_you_want, :string, null: false, default: 'pending', index: true

  create_statesman_trigger Order, OrderTransition, sync_column: :anything_you_want
end
```

It is highly recommended you switch your Rails application's schema dumping format to SQL (`db/structure.sql` rather than `db/schema.rb`). That's accomplished by the following line in `config/application.rb`:

```ruby
module YourAppHere
  class Application < Rails::Application
    # Use SQL for dumping.
    config.active_record.schema_format = :sql
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/scryptmouse/statesman-trigger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
