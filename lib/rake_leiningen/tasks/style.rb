require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Style < RakeFactory::Task
      include Mixins::Directoried

      default_name :style
      default_description "Make all clojure files conform to a style."
      default_prerequisites RakeFactory::DynamicValue.new { |t|
        t.ensure_task_name ? [t.ensure_task_name] : []
      }

      parameter :mode
      parameter :paths

      parameter :directory, default: '.'

      parameter :ensure_task_name, default: 'leiningen:ensure'

      action do |t|
        puts "Styling all clojure files..."

        in_directory(t.directory) do
          RubyLeiningen.cljstyle(
              mode: t.mode,
              paths: t.paths)
        end
      end
    end
  end
end
