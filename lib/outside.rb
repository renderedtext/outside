require "outside/version"
require "outside/options"
require "timeout"

module Outside

  module_function

  def go(*options)
    duration = Options.duration(options)
    handle   = Options.handle?(options)

    Timeout.timeout(duration) { yield }
  rescue Timeout::Error => exception
    raise exception unless handle
  end

end
