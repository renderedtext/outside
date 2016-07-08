module Outside
  module Options

    module_function

    DEFAULT_TIMEOUT = 5
    DEFAULT_RETRY_COUNT = 0
    DEFAULT_RETRY_INTERVAL = 0

    def duration(options)
      option_value(options, :duration) || DEFAULT_TIMEOUT
    end

    def retry_count(options)
      option_value(options, :retry_count) || DEFAULT_RETRY_COUNT
    end

    def retry_interval(options)
      option_value(options, :retry_interval) || DEFAULT_RETRY_INTERVAL
    end

    def handle?(options)
      option_enabled?(options, :handle)
    end

    def option_value(options, option_name)
      options
        .select { |option| option.is_a?(Hash) }
        .map(&:first)
        .select { |key, value| key == option_name }
        .map { |key, value| value }
        .first
    end

    def option_enabled?(options, option_name)
      options.any? { |arg| arg == option_name }
    end

  end
end
