require 'rake_factory'

require_relative '../tasks/lint'
require_relative '../tasks/optimise'
require_relative '../tasks/idiomise'
require_relative '../tasks/format'
require_relative '../tasks/pedantise'
require_relative '../tasks/check'

module RakeLeiningen
  module TaskSets
    class Checks < RakeFactory::TaskSet
      parameter :argument_names, default: []

      parameter :profile
      parameter :directory, default: '.'
      parameter :fix, default: false

      parameter :ensure_task_name, default: 'leiningen:ensure'

      parameter :lint_task_name, :default => :lint
      parameter :optimise_task_name, :default => :optimise
      parameter :idiomise_task_name, :default => :idiomise
      parameter :format_task_name, :default => :format
      parameter :pedantise_task_name, :default => :pedantise
      parameter :check_task_name, :default => :check

      task Tasks::Lint,
          name: ->(ts) { ts.lint_task_name }
      task Tasks::Optimise,
          name: ->(ts) { ts.optimise_task_name }
      task Tasks::Idiomise,
          name: ->(ts) { ts.idiomise_task_name },
          replace: ->(ts) { ts.fix }
      task Tasks::Format,
          name: ->(ts) { ts.format_task_name },
          mode: ->(ts) { ts.fix ? :fix : :check }
      task Tasks::Pedantise,
          name: ->(ts) { ts.pedantise_task_name }
      task Tasks::Check,
          name: ->(ts) { ts.check_task_name }
    end
  end
end
