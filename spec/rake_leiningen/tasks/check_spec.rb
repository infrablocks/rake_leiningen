require 'spec_helper'

describe RakeLeiningen::Tasks::Check do
  include_context :rake

  before(:each) do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a check task in the namespace in which it is created' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task.task_defined?('something:check')).to(be(true))
  end

  it 'gives the check task a description' do
    namespace :something do
      subject.define
    end

    expect(Rake::Task["something:check"].full_comment)
        .to(eq("Perform all checks against clojure files."))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      subject.define(name: :do_all_checks)
    end

    expect(Rake::Task.task_defined?("something:do_all_checks")).to(be(true))
  end

  it 'allows multiple check tasks to be declared' do
    namespace :something1 do
      subject.define
    end

    namespace :something2 do
      subject.define
    end

    expect(Rake::Task.task_defined?("something1:check")).to(be(true))
    expect(Rake::Task.task_defined?("something2:check")).to(be(true))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = [:deployment_identifier, :region]

    namespace :something do
      subject.define(argument_names: argument_names)
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

      subject.define
    end

    expect(Rake::Task["something:check"].prerequisite_tasks)
        .to(eq([
            Rake::Task["something:lint"],
            Rake::Task["something:optimise"],
            Rake::Task["something:idiomise"],
            Rake::Task["something:format"],
            Rake::Task["something:pedantise"],
        ]))
  end

  it 'depends on tasks with the provided names when specified' do
    namespace :something do
      task :eastwood
      task :check_reflection
      task :kibit
      task :cljfmt
      task :bikeshed

      subject.define(
          lint_task_name: :eastwood,
          optimise_task_name: :check_reflection,
          idiomise_task_name: :kibit,
          format_task_name: :cljfmt,
          pedantise_task_name: :bikeshed)
    end

    expect(Rake::Task["something:check"].prerequisite_tasks)
        .to(eq([
            Rake::Task["something:eastwood"],
            Rake::Task["something:check_reflection"],
            Rake::Task["something:kibit"],
            Rake::Task["something:cljfmt"],
            Rake::Task["something:bikeshed"],
        ]))
  end
end
