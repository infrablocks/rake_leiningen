# frozen_string_literal: true

require 'spec_helper'

describe RakeLeiningen::Tasks::Check do
  include_context 'rake'

  before do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a check task in the namespace in which it is created' do
    namespace :something do
      described_class.define
    end

    expect(Rake.application)
      .to(have_task_defined('something:check'))
  end

  it 'gives the check task a description' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:check'].full_comment)
      .to(eq('Perform all checks against clojure files.'))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      described_class.define(name: :do_all_checks)
    end

    expect(Rake.application)
      .to(have_task_defined('something:do_all_checks'))
  end

  it 'allows multiple check tasks to be declared' do
    namespace :something1 do
      described_class.define
    end

    namespace :something2 do
      described_class.define
    end

    expect(Rake.application)
      .to(have_tasks_defined(
            %w[something1:check
               something2:check]
          ))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = %i[deployment_identifier region]

    namespace :something do
      described_class.define(argument_names:)
    end

    expect(Rake::Task['something:check'].arg_names)
      .to(eq(argument_names))
  end

  it 'depends on all check tasks by default' do
    namespace :something do
      task :lint
      task :optimise
      task :idiomise
      task :format
      task :pedantise

      described_class.define
    end

    expect(Rake::Task['something:check'].prerequisite_tasks)
      .to(eq([
               Rake::Task['something:lint'],
               Rake::Task['something:optimise'],
               Rake::Task['something:idiomise'],
               Rake::Task['something:format'],
               Rake::Task['something:pedantise']
             ]))
  end

  it 'depends on tasks with the provided names when specified' do
    namespace :something do
      task :eastwood
      task :check_reflection
      task :kibit
      task :cljfmt
      task :bikeshed

      described_class.define(
        lint_task_name: :eastwood,
        optimise_task_name: :check_reflection,
        idiomise_task_name: :kibit,
        format_task_name: :cljfmt,
        pedantise_task_name: :bikeshed
      )
    end

    expect(Rake::Task['something:check'].prerequisite_tasks)
      .to(eq([
               Rake::Task['something:eastwood'],
               Rake::Task['something:check_reflection'],
               Rake::Task['something:kibit'],
               Rake::Task['something:cljfmt'],
               Rake::Task['something:bikeshed']
             ]))
  end
end
