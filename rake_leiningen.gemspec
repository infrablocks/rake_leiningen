# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake_leiningen/version'

Gem::Specification.new do |spec|
  spec.name = 'rake_leiningen'
  spec.version = RakeLeiningen::VERSION
  spec.authors = ['InfraBlocks Maintainers']
  spec.email = ['maintainers@infrablocks.io']

  spec.summary = 'Rake tasks for interoperating with a leiningen project.'
  spec.description = 'Rake tasks for common leiningen commands allowing ' +
      'a leiningen project to be managed as part of a build.'
  spec.homepage = "https://github.com/infrablocks/rake_leiningen"
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(bin|lib|CODE_OF_CONDUCT\.md|confidante\.gemspec|Gemfile|LICENSE\.txt|Rakefile|README\.md)})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'rake_dependencies', '~> 2.13'
  spec.add_dependency 'rake_factory', '~> 0.23'
  spec.add_dependency 'ruby_leiningen', '~> 0.21'
  spec.add_dependency 'semantic', '~> 1.6'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake_circle_ci'
  spec.add_development_dependency 'rake_github'
  spec.add_development_dependency 'rake_ssh'
  spec.add_development_dependency 'rake_gpg'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'gem-release'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'fakefs'
  spec.add_development_dependency 'simplecov'
end
