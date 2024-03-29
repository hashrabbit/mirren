require_relative 'lib/mirren/version'

Gem::Specification.new do |spec|
  spec.name          = 'mirren'
  spec.version       = Mirren::VERSION
  spec.authors       = ['Brian V. Hughes']
  spec.email         = ['brianvh89@gmail.com']

  spec.summary       = %q{Mining Rig Rentals API Client SDK}
  spec.homepage      = 'https://github.com/hashrabbit/mirren'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'http://rubygems.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/hashrabbit/mirren'
  spec.metadata['changelog_uri'] = 'https://github.com/hashrabbit/mirren/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'dry-configurable', '~> 0.11.4'
  spec.add_runtime_dependency 'dry-initializer', '~> 3.0.3'
  spec.add_runtime_dependency 'dry-struct', '~> 1.3.0'
  spec.add_runtime_dependency 'dry-monads', '~> 1.3.0'
  spec.add_runtime_dependency 'json', '~> 2.3.0'
  spec.add_runtime_dependency 'rest-client', '~> 2.1.0'

  spec.add_development_dependency 'bundler', '~> 2.1.2'
  spec.add_development_dependency 'rake', '~> 13.0.1'
  spec.add_development_dependency 'dotenv', '~> 2.7.5'
  spec.add_development_dependency 'rspec', '~> 3.9.0'
end
