# frozen_string_literal: true

require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Pedantise < RakeFactory::Task
      include Mixins::Directoried

      default_name :pedantise
      default_description "Hunt for 'bad' code in all clojure files."
      default_prerequisites(RakeFactory::DynamicValue.new do |t|
        t.ensure_task_name ? [t.ensure_task_name] : []
      end)

      parameter :show_help
      parameter :verbose
      parameter :maximum_line_length
      parameter :long_lines
      parameter :trailing_whitespace
      parameter :trailing_blank_lines
      parameter :var_redefs
      parameter :docstrings
      parameter :name_collisions
      parameter :exclude_profiles
      parameter :profile
      parameter :environment

      parameter :directory, default: '.'

      parameter :ensure_task_name, default: 'leiningen:ensure'

      action do |t|
        $stdout.puts "Looking for 'bad' code in all clojure files..."

        in_directory(t.directory) do
          RubyLeiningen.bikeshed(
            show_help: t.show_help,
            verbose: t.verbose,
            maximum_line_length: t.maximum_line_length,
            long_lines: t.long_lines,
            trailing_whitespace: t.trailing_whitespace,
            trailing_blank_lines: t.trailing_blank_lines,
            var_redefs: t.var_redefs,
            docstrings: t.docstrings,
            name_collisions: t.name_collisions,
            exclude_profiles: t.exclude_profiles,
            profile: t.profile,
            environment: t.environment
          )
        end
      end
    end
  end
end
