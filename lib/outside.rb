require "outside/version"
require "outside/execution"
require "timeout"

module Outside

  module_function

  def go(options = {})
    Execution.new(options).run { yield }
  end

end
