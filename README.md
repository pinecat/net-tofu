# OpenTOFU

OpenTOFU is a certificate pinning and client library for Geminispace.
It is based off of the ['trust on first use'](https://en.wikipedia.org/wiki/Trust_on_first_use) authentication scheme.

## Installation

To install the gem standalone:

```sh
gem install opentofu
```

Or to use it as part of a project, place the following line in your Gemfile, then run `bundle install` in your project directory:

```ruby
gem "opentofu", "~> 0.1.0"
```

## Usage

```ruby
require "net/tofu"
```

## Credits

I'd like to thank Étienne Deparis, author of [ruby-net-text](https://git.umaneti.net/ruby-net-text/) for releasing their code under the MIT license so that some of it can be used in this project. In particular, `lib/ui/gemini.rb` is taken straight from that codebase. The license for it is present in the aformentioned file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pinecat/opentofu.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
