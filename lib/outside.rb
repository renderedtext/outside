require "outside/version"
require "timeout"

module Outside

  module_function

  def go(timeout = 5)
    Timeout.timeout(timeout) { yield }
  end

end
