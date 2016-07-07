module Outside
  module Options

    module_function

    DEFAULT_TIMEOUT = 5

    def duration(options)
      options
        .select { |option| option.is_a?(Hash) }
        .map(&:first)
        .select { |key, value| key == :duration }
        .map { |key, value| value }
        .first || DEFAULT_TIMEOUT
    end

    def handle?(options)
      options.any? { |arg| arg == :handle }
    end

  end
end
