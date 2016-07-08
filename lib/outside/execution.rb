module Outside
  class Execution

    DEFAULT_TIMEOUT = 5
    DEFAULT_RETRY_COUNT = 0
    DEFAULT_RETRY_INTERVAL = 0

    def initialize(options)
      @duration = options[:duration] || DEFAULT_TIMEOUT
      @retry_count = options[:retry_count] || DEFAULT_RETRY_COUNT
      @retry_interval = options[:retry_interval] || DEFAULT_RETRY_INTERVAL
      @handle = options[:handle] || false
    end

    def run
      tries ||= @retry_count

      Timeout.timeout(@duration) { yield }
    rescue Timeout::Error => exception
      if tries.zero?
        raise exception unless @handle
      else
        tries -= 1
        sleep @retry_interval
        retry
      end

      nil
    end

  end
end
