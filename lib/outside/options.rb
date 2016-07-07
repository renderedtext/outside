module Outside
  module Options

    module_function

    DEFAULT_TIMEOUT = 5

    def timeout_duration(options)
      options
        .select { |option| option.is_a?(Hash) }
        .map(&:first)
        .select { |key, value| key == :timeout }
        .map { |key, value| value }
        .first || DEFAULT_TIMEOUT
    end

    def handle_timeout?(options)
      options.any? { |arg| arg == :handle_timeout }
    end

  end
end
