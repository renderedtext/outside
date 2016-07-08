module Outside
  class Execution

    # Default values
    ITERATION_LIMIT = 5 # seconds
    RETRY_COUNT = 0
    INTERVAL_DURATION = 0 # seconds
    INTERVAL_INCREMENT = 0 # seconds
    INTERVAL_FACTOR = 1
    INTERVAL_RANDOMNESS = 0
    INTERVAL_LIMIT = Float::MAX # seconds

    def initialize(options = {})
      @iteration_limit = options[:iteration_limit] || ITERATION_LIMIT
      @retry_count = options[:retry_count] || RETRY_COUNT
      @interval_duration = options[:interval_duration] || INTERVAL_DURATION
      @interval_increment = options[:interval_increment] || INTERVAL_INCREMENT
      @interval_factor = options[:interval_factor] || INTERVAL_FACTOR
      @interval_randomness = options[:interval_randomness] || INTERVAL_RANDOMNESS
      @interval_limit = options[:interval_limit] || INTERVAL_LIMIT
      @handle_timeout = options[:handle_timeout] || false
    end

    def run
      tries ||= @retry_count
      interval ||= @interval_duration

      Timeout.timeout(@iteration_limit) { yield }
    rescue Timeout::Error => exception
      if tries.zero?
        raise exception unless @handle_timeout
      else
        sleep_for_interval(interval)
        tries -= 1
        interval = update_interval(interval)
        retry
      end
      nil
    end

    private

    def random_factor
      range_min = 1 - @interval_randomness
      range_max = 1 + @interval_randomness

      Random.rand(range_min..range_max)
    end

    def sleep_for_interval(interval)
      sleep [random_factor * interval, @interval_limit].min
    end

    def update_interval(interval)
      interval * @interval_factor + @interval_increment
    end

  end
end
