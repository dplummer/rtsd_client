# Rtsd

A Ruby client for OpenTSDB.

* Initial release planned to just support write API.

## Installation

Add this line to your application's Gemfile:

    gem 'rtsd'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rtsd

## Usage

```ruby
client = Rtsd::Client.new(:hostname => 'localhost', :port => 4242)

client.put(:metric => 'cheezeburgers.per_second',
           :value => 9001,
           :timestamp => Time.now.to_i,
           :tags => {:ya => 'nope', :host => 'strongbadia'})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
