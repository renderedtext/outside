# Outside

![Kindergarten Cop](http://www.showbiz411.com/wp-content/uploads/2015/06/Kindergarten-Cop-1-DI.jpg)

Watches after your blocks of code and makes sure that they find their way back home.

## Description

Currently wraps blocks of code (for example those handling outbound connections) into a timeout block. The idea is to add all of the generic things that should wrap connections and similar cases right here. Feel free to expand the gem.

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
- `:iteration_limit` - Timeout duration for one iteration. Default value is 5 seconds.
- `:total_limit` - Timeout duration for all of iterations (first one plus the retries). Default value is 3600 seconds (1 hour).
- `:retry_count` - Retry count. Default is 0.
- `:interval_duration` - Interval between retries. Default is 0.
- `:interval_increment` - Value by which the interval is incremented between retries. Default is 0.
- `:interval_factor` - Factor by which the interval is multiplied between retries. Default is 1.
- `:interval_randomness` - Range of randomness for the random factor (see interval calculation below). It is a number between 0 and 1. Random factor will be a number in the range of (1 - interval_randomness, 1 + interval_randomness). Default is 0, meaning that the random factor will be 1 and therefore the interval will remain unchanged.
- `:interval_limit` - Maximum interval value. Not set by default.
- `:handle_timeout` - Sets if `Timeout::Error` will be raised in case of a timeout. If it is false, it will not raise anything and it will return `nil`. Default value is true.

All temporal values are in seconds.

Interval calculation:
```
iteration_interval = random_factor * (interval_factor * previous_iteration_interval + interval_increment)
```

Example with options:

```
options = {
  :iteration_limit => 10,
  :retry_count => 3,
  :interval_duration => 5
}

Outside.go(options) do
  # code
end
```
