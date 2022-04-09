# frozen_string_literal: true

require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Optimise < RakeFactory::Task
      include Mixins::Directoried

      default_name :optimise
      default_description 'Warn on reflection for all clojure files.'
      default_prerequisites(RakeFactory::DynamicValue.new do |t|
        t.ensure_task_name ? [t.ensure_task_name] : []
      end)

      parameter :profile
      parameter :environment

      parameter :directory, default: '.'

      parameter :ensure_task_name, default: 'leiningen:ensure'

      action do |t|
        $stdout.puts 'Checking for uses of reflection in all clojure files...'

        in_directory(t.directory) do
          RubyLeiningen.check(
            profile: t.profile,
            environment: t.environment
          )
        end
      end
    end
  end
end
