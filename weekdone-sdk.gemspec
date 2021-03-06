require_relative 'lib/weekdone/version'

Gem::Specification.new do |spec|
  spec.name          = "weekdone-sdk"
  spec.version       = Weekdone::VERSION
  spec.authors       = ["thaim"]
  spec.email         = ["thaim24@gmail.com"]

  spec.summary       = "A Ruby gem for communicating with the Weekdone REST API"
  spec.description   = "A Ruby gem for communicating with the Weekdone REST API"
  spec.homepage      = "https://github.com/thaim/weekdone-sdk-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/thaim/weekdone-sdk-ruby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'oauth2', '~> 1.4'
  spec.add_runtime_dependency 'faraday', '~> 1.0'
end
