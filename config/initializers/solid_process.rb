# frozen_string_literal: true

require "rails_event_logs_logger_listener"

BCDD::Result.configuration do |config|
  config.event_logs.listener = RailsEventLogsLoggerListener
end
