# Intermix::Client

Intermix is an analytics platform that instruments Amazon Redshift to improve performance, reduce costs, and eliminate downtime. Our SaaS product intelligently tunes databases in the cloud, provides deep analytics, recommendations, and predictions, so companies don't have to hire DBA experts, throw money at performance problems, or deal with slow queries.
This gem helps to interact with the Intermix API.

To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'intermix-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install intermix-client

## Usage

#### Creating a client
Before performing any operation through the intermix api, we need an instance of `Intermix::Client`.
```
require 'intermix'

configuration = Intermix::Configuration.new(api_token: 'token', cluster_id: 1)
client        = Intermix::Client.new(configuration)
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tophatter/intermix-client.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
