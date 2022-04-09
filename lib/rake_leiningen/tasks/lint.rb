# frozen_string_literal: true

require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Lint < RakeFactory::Task
      include Mixins::Directoried

      default_name :lint
      default_description 'Lint all clojure files.'
      default_prerequisites(RakeFactory::DynamicValue.new do |t|
        t.ensure_task_name ? [t.ensure_task_name] : []
      end)

      parameter :config
      parameter :profile
      parameter :environment

      parameter :directory, default: '.'

      parameter :ensure_task_name, default: 'leiningen:ensure'

      action do |t|
        $stdout.puts 'Linting all clojure files...'

        in_directory(t.directory) do
          RubyLeiningen.eastwood(
            config: t.config,
            profile: t.profile,
            environment: t.environment
          )
        end
      end
    end
  end
end
