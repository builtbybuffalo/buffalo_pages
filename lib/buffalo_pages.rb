require "buffalo_pages/version"
require "date_time"
require "friendly_id"

module BuffaloPages
  if defined?(Rails)
    require "buffalo_pages/engine"
  end

  def self.root
    File.dirname(__FILE__).sub(/\/lib$/, "")
  end
end
