# frozen_string_literal: true

require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Test < RakeFactory::Task
      include Mixins::Directoried

      default_name :test
      default_description(RakeFactory::DynamicValue.new do |t|
        "Run #{t.type ? "all #{t.type}" : 'all'} tests."
      end)
      default_prerequisites(RakeFactory::DynamicValue.new do |t|
        t.ensure_task_name ? [t.ensure_task_name] : []
      end)

      parameter :type

      parameter :only
      parameter :test_selectors
      parameter :namespaces
      parameter :files
      parameter :profile
      parameter :environment

      parameter :directory, default: '.'

      parameter :ensure_task_name, default: 'leiningen:ensure'

      action do |t|
        $stdout.puts "Running #{t.type ? "all #{t.type}" : 'all'} tests..."

        in_directory(t.directory) do
          RubyLeiningen.eftest(
            only: t.only,
            test_selectors: t.test_selectors,
            namespaces: t.namespaces,
            files: t.files,
            profile: t.profile,
            environment: t.environment
          )
        end
      end
    end
  end
end
