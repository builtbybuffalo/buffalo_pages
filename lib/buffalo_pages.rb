require "buffalo_pages/version"

module BuffaloPages
  if defined?(Rails)
    require "buffalo_pages/engine"
  end
end
