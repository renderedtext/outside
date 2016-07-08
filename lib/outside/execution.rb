module Outside
  class Execution

    def initialize(options)
      @duration = Options.duration(options)
      @retry_interval = Options.retry_interval(options)
      @retry_count = Options.retry_count(options)
      @handle = Options.handle?(options)
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
