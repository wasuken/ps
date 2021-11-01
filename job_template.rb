require "csv"
require "json"

class Job
  attr_reader :ignite_interval, :ignite_time, :config, :name

  def initialize(config, name)
    @config = config
    @name = name
    @ignite_interval = @config["default_internal"] || 3
    self.reload
  end

  def reload(ig = nil)
    @ignite_interval = ig if ig
    @ignite_time = DateTime.now + @ignite_interval
  end

  def call()
  end
end
