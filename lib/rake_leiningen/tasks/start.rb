# frozen_string_literal: true

require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Start < RakeFactory::Task
      include Mixins::Directoried

      default_name :start
      default_description 'Run the application.'
      default_prerequisites(RakeFactory::DynamicValue.new do |t|
        t.ensure_task_name ? [t.ensure_task_name] : []
      end)

      parameter :main_function
      parameter :arguments
      parameter :quote_arguments
      parameter :profile
      parameter :environment

      parameter :directory, default: '.'

      parameter :ensure_task_name, default: 'leiningen:ensure'

      action do |t|
        $stdout.puts 'Running the application...'

        in_directory(t.directory) do
          RubyLeiningen.run(
            main_function: t.main_function,
            arguments: t.arguments,
            quote_arguments: t.quote_arguments,
            profile: t.profile,
            environment: t.environment
          )
        end
      end
    end
  end
end
