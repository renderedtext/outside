# Outside

Currently wraps outbound connections into a timeout block. The idea is to add all of the generic things that should wrap connections right here. Feel free to expand the gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'outside'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install outside

## Usage

```
Outside.go(options) do
  # code
end
```

Default behavior is the following: if the block passed to the method does not finish executing in the given time (default is 5 seconds), it will be stopped and a `Timeout::Error` will be raised.

Possible options for changing the default behavior are:
- `:handle` - `Timeout::Error` will not be raised in case of a timeout; `nil` value will be returned.
- `:duration` - Sets a custom timeout time. Default value is 5 seconds. Format is: `{ :duration => 10 }`
- `:retry_count` - Sets a custom retry count. Default is 0. Format is: `{ :retry_count => 3 }`
- `:retry_interval` - Sets a custom interval between retries. Default is 0. Format is: `{ :retry_interval => 5 }`

Example with options:

```
Outside.go(:handle, { :duration => 10 }, { :retry_count => 3}, { :retry_interval => 5}) do
  # code
end
```
