require 'health_monitor/configuration'

module HealthMonitor
  extend self

  attr_accessor :configuration

  def configure
    self.configuration ||= Configuration.new

    yield configuration if block_given?
  end

  def check!(request: nil)
    configuration.providers.each do |provider|
      monitor = provider.new(request: request)
      monitor.check!
    end
  rescue => e
    configuration.error_callback.call(e) if configuration.error_callback

    raise
  end
end

HealthMonitor.configure
