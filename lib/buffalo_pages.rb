require "buffalo_pages/version"
require "date_time"

module BuffaloPages
  if defined?(Rails)
    require "buffalo_pages/engine"
  end

  def self.root
    File.dirname(__FILE__).sub(/\/lib$/, "")
  end
end
