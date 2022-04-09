# frozen_string_literal: true

require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Release < RakeFactory::Task
      include Mixins::Directoried

      default_name :release
      default_description 'Release library.'
      default_prerequisites(RakeFactory::DynamicValue.new do |t|
        t.ensure_task_name ? [t.ensure_task_name] : []
      end)

      parameter :level
      parameter :profile
      parameter :environment

      parameter :directory, default: '.'

      parameter :ensure_task_name, default: 'leiningen:ensure'

      action do |t|
        $stdout.puts 'Releasing library...'

        in_directory(t.directory) do
          RubyLeiningen.release(
            level: t.level,
            profile: t.profile,
            environment: t.environment
          )
        end
      end
    end
  end
end
