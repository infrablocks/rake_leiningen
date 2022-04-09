# frozen_string_literal: true

require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Build < RakeFactory::Task
      include Mixins::Directoried

      default_name :build
      default_description 'Build standalone uberjar.'
      default_prerequisites(RakeFactory::DynamicValue.new do |t|
        t.ensure_task_name ? [t.ensure_task_name] : []
      end)

      parameter :main_namespace
      parameter :profile
      parameter :environment

      parameter :directory, default: '.'

      parameter :ensure_task_name, default: 'leiningen:ensure'

      action do |t|
        $stdout.puts 'Building standalone uberjar...'

        in_directory(t.directory) do
          RubyLeiningen.uberjar(
            main_namespace: t.main_namespace,
            profile: t.profile,
            environment: t.environment
          )
        end
      end
    end
  end
end
