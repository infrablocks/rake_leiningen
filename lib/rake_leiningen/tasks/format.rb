# frozen_string_literal: true

require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Format < RakeFactory::Task
      include Mixins::Directoried

      default_name :format
      default_description 'Format all clojure files.'
      default_prerequisites(RakeFactory::DynamicValue.new do |t|
        t.ensure_task_name ? [t.ensure_task_name] : []
      end)

      parameter :mode
      parameter :paths
      parameter :profile
      parameter :environment

      parameter :directory, default: '.'

      parameter :ensure_task_name, default: 'leiningen:ensure'

      action do |t|
        $stdout.puts 'Formatting all clojure files...'

        in_directory(t.directory) do
          RubyLeiningen.cljfmt(
            mode: t.mode,
            paths: t.paths,
            profile: t.profile,
            environment: t.environment
          )
        end
      end
    end
  end
end
