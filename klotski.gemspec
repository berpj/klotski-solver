# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'klotski/version'

Gem::Specification.new do |spec|
  spec.name          = "klotski"
  spec.version       = Klotski::VERSION
  spec.authors       = ["Pierre-Jean Bergeron"]
  spec.email         = ["pierrejeanbergeron@gmail.com"]

  spec.summary       = %q{Klotski solver}
  spec.description   = %q{Klotski solver}
  spec.homepage      = "http://pierrejeanbergeron.fr"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://mygemserver.com.old"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  #spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files += Dir['config/*', 'lib/**/*', 'keys/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubytree", "~> 0.9.6"
end
