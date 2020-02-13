# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake_leiningen/version'

Gem::Specification.new do |spec|
  spec.name = 'rake_leiningen'
  spec.version = RakeLeiningen::VERSION
  spec.authors = ['Toby Clemson']
  spec.email = ['tobyclemson@gmail.com']

  spec.summary = 'Rake tasks for interoperating with a leiningen project.'
  spec.description = 'Rake tasks for common leiningen commands allowing ' +
      'a leiningen project to be managed as part of a build.'
  spec.homepage = "https://github.com/logicblocks/rake_leiningen"
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6.0'

  spec.add_dependency 'rake_dependencies', '~> 2', '< 3'
  spec.add_dependency 'rake_factory', '>= 0.23', '< 1'
  spec.add_dependency 'ruby_leiningen', '~> 0.5'
  spec.add_dependency 'semantic', '~> 1.6.1'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'gem-release', '~> 2.0'
  spec.add_development_dependency 'activesupport', '>= 5.2'
  spec.add_development_dependency 'fakefs', '~> 1.0'
  spec.add_development_dependency 'simplecov', '~> 0.16'
end
