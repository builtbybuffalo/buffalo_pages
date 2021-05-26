# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'buffalo_pages/version'

Gem::Specification.new do |spec|
  spec.name          = "buffalo_pages"
  spec.version       = BuffaloPages::VERSION
  spec.authors       = ["jaspertandy"]
  spec.email         = ["jspr@tndy.me"]

  spec.summary       = %q{Interface for creating pages}
  spec.description   = %q{Create and manage pages using Rails}
  spec.homepage      = "https://github.com/builtbybuffalo/buffalo_pages"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["app", "lib"]

  spec.add_development_dependency "bundler", ">= 2.2.10"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_runtime_dependency "friendly_id", "~> 5.1.0"
  spec.add_runtime_dependency "paperclip", ">= 5.2.0"
  spec.add_runtime_dependency "acts_as_list"
  spec.add_runtime_dependency "city-state"
  spec.add_runtime_dependency "delayed_paperclip"
end
