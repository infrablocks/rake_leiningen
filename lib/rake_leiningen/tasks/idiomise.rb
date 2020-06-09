require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Idiomise < RakeFactory::Task
      include Mixins::Directoried

      default_name :idiomise
      default_description "Transform all clojure files to be more idiomatic."
      default_prerequisites RakeFactory::DynamicValue.new { |t|
        t.ensure_task_name ? [t.ensure_task_name] : []
      }

      parameter :replace
      parameter :interactive
      parameter :reporter
      parameter :paths
      parameter :profile
      parameter :environment

      parameter :directory, default: '.'

      parameter :ensure_task_name, default: 'leiningen:ensure'

      action do |t|
        puts "Making all clojure files more idiomatic..."

        in_directory(t.directory) do
          RubyLeiningen.kibit(
              replace: t.replace,
              interactive: t.interactive,
              reporter: t.reporter,
              paths: t.paths,
              profile: t.profile,
              environment: t.environment)
        end
      end
    end
  end
end
