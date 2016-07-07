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

Default behavior is the following: if the block passed to the method does not finish executing in 5 seconds, it will be stopped and a `Timeout::Error` will be raised.

Possible options for changing the default behavior are:
- `:handle_timeout` - Method will not propagate `Timeout::Error` in case of a timeout.
- `:timeout_duration` - Sets a custom timeout time. Default value is 5 seconds. Format is: `{ :timeout_duration => 10 }`

Example with options:

```
Outside.go(:handle_timeout, { :timeout_duration => 10 }) do
  # code
end
```
