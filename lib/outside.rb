require "outside/version"
require "outside/execution"
require "timeout"

module Outside

  TOTAL_LIMIT = 3600 # seconds

  module_function

  def go(options = {})
    total_limit = options[:total_limit] || TOTAL_LIMIT
    handle_timeout = options[:handle_timeout] || false

    Timeout.timeout(total_limit) do
      Execution.new(options).run { yield }
    end
  rescue Timeout::Error => exception
    raise exception unless handle_timeout
    nil
  end

end
