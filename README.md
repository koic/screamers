# Screamers [![Build Status](https://travis-ci.org/koic/screamers.svg)](https://travis-ci.org/koic/screamers) [![Gem Version](https://badge.fury.io/rb/screamers.svg)](http://badge.fury.io/rb/screamers)

Generate a migration file that converts column types all at once.

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem 'screamers'
```

And then execute:

```console
% bundle install
```

The following subcommand will be added to the `rails g` command.

```console
Screamers:
  screamers:migration
```

## Synopsis

```console
bin/rails g screamers:migration OLD_COLUMN_TYPE NEW_COLUMN_TYPE
```

## Usage

Here is an example of converting `date` type to `datetime` type.

```console
% bin/rails g screamers:migration date datetime
      create  db/migrate/20170628144908_change_date_to_datetime_using_screamers.rb
```

Generate a migration file that converts column types all at once.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/koic/screamers.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
