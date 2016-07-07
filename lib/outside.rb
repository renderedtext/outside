require "outside/version"
require "timeout"

module Outside

  module_function

  DEFAULT_TIMEOUT = 5

  def go(*arguments)
    arguments.is_a?(Hash)
    timeout = arguments
      .select { |arg| arg.is_a?(Hash) }
      .map { |arg| arg.first }
      .select { |key, value| key == :timeout }
      .map { |key, value| value }
      .first || DEFAULT_TIMEOUT

    handle_exceptions = arguments.any? { |arg| arg == :handle_timeout }

    Timeout.timeout(timeout) { yield }
  rescue Timeout::Error => e
    raise e unless handle_exceptions
  end

end
