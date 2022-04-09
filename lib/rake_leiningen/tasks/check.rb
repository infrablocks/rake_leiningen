# frozen_string_literal: true

require 'rake_factory'
require 'ruby_leiningen'
require 'ruby_leiningen/plugins'

require_relative '../mixins/directoried'

module RakeLeiningen
  module Tasks
    class Check < RakeFactory::Task
      include Mixins::Directoried

      default_name :check
      default_description 'Perform all checks against clojure files.'
      default_prerequisites(RakeFactory::DynamicValue.new do |t|
        [
          t.lint_task_name,
          t.optimise_task_name,
          t.idiomise_task_name,
          t.format_task_name,
          t.pedantise_task_name
        ]
      end)

      parameter :lint_task_name, default: :lint
      parameter :optimise_task_name, default: :optimise
      parameter :idiomise_task_name, default: :idiomise
      parameter :format_task_name, default: :format
      parameter :pedantise_task_name, default: :pedantise
    end
  end
end
