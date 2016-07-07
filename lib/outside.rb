require "outside/version"
require "outside/options"
require "timeout"

module Outside

  module_function

  def go(*options)
    timeout_duration = Options.timeout_duration(options)
    handle_timeout   = Options.handle_timeout?(options)

    Timeout.timeout(timeout_duration) { yield }
  rescue Timeout::Error => exception
    raise exception unless handle_timeout
  end

end
