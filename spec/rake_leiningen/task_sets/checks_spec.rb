require 'spec_helper'

describe RakeLeiningen::TaskSets::Checks do
  include_context :rake

  context 'lint task' do
    it 'configures with passed parameters' do
      profile = 'test'
      directory = 'module1'
      ensure_task_name = 'lein:ensure'

      namespace :lein do
        task :ensure
      end

      namespace :something do
        subject.define(
            profile: profile,
            directory: directory,
            ensure_task_name: ensure_task_name)
      end

      rake_task = Rake::Task["something:lint"]

      expect(rake_task.creator.profile).to(eq(profile))
      expect(rake_task.creator.directory).to(eq(directory))
      expect(rake_task.creator.ensure_task_name).to(eq(ensure_task_name))
    end

    it 'uses the provided lint task name when present' do
      namespace :something do
        subject.define(lint_task_name: :eastwood)
      end

      expect(Rake::Task.task_defined?("something:eastwood")).to(be(true))
    end

    it 'uses the provided argument names when present' do
      argument_names = [:argument, :names]

      namespace :something do
        subject.define(
            argument_names: argument_names)
      end

      rake_task = Rake::Task["something:lint"]

      expect(rake_task.arg_names).to(eq(argument_names))
    end
  end

  context 'optimise task' do
    it 'configures with passed parameters' do
      profile = 'test'
      directory = 'module1'
      ensure_task_name = 'lein:ensure'

      namespace :lein do
        task :ensure
      end

      namespace :something do
        subject.define(
            profile: profile,
            directory: directory,
            ensure_task_name: ensure_task_name)
      end

      rake_task = Rake::Task["something:optimise"]

      expect(rake_task.creator.profile).to(eq(profile))
      expect(rake_task.creator.directory).to(eq(directory))
      expect(rake_task.creator.ensure_task_name).to(eq(ensure_task_name))
    end

    it 'uses the provided optimise task name when present' do
      namespace :something do
        subject.define(optimise_task_name: :check_reflection)
      end

      expect(Rake::Task.task_defined?("something:check_reflection"))
          .to(be(true))
    end

    it 'uses the provided argument names when present' do
      argument_names = [:argument, :names]

      namespace :something do
        subject.define(
            argument_names: argument_names)
      end

      rake_task = Rake::Task["something:optimise"]

      expect(rake_task.arg_names).to(eq(argument_names))
    end
  end

  context 'idiomise task' do
    it 'configures with passed parameters' do
      profile = 'test'
      directory = 'module1'
      ensure_task_name = 'lein:ensure'

      namespace :lein do
        task :ensure
      end

      namespace :something do
        subject.define(
            profile: profile,
            directory: directory,
            ensure_task_name: ensure_task_name)
      end

      rake_task = Rake::Task["something:idiomise"]

      expect(rake_task.creator.profile).to(eq(profile))
      expect(rake_task.creator.directory).to(eq(directory))
      expect(rake_task.creator.ensure_task_name).to(eq(ensure_task_name))
    end

    it 'uses the provided idiomise task name when present' do
      namespace :something do
        subject.define(optimise_task_name: :kibit)
      end

      expect(Rake::Task.task_defined?("something:kibit")).to(be(true))
    end

    it 'uses the provided argument names when present' do
      argument_names = [:argument, :names]

      namespace :something do
        subject.define(
            argument_names: argument_names)
      end

      rake_task = Rake::Task["something:idiomise"]

      expect(rake_task.arg_names).to(eq(argument_names))
    end
  end

  context 'format task' do
    it 'configures with passed parameters' do
      profile = 'test'
      directory = 'module1'
      ensure_task_name = 'lein:ensure'

      namespace :lein do
        task :ensure
      end

      namespace :something do
        subject.define(
            profile: profile,
            directory: directory,
            ensure_task_name: ensure_task_name)
      end

      rake_task = Rake::Task["something:format"]

      expect(rake_task.creator.profile).to(eq(profile))
      expect(rake_task.creator.directory).to(eq(directory))
      expect(rake_task.creator.ensure_task_name).to(eq(ensure_task_name))
    end

    it 'uses the provided format task name when present' do
      namespace :something do
        subject.define(optimise_task_name: :cljfmt)
      end

      expect(Rake::Task.task_defined?("something:cljfmt")).to(be(true))
    end

    it 'uses the provided argument names when present' do
      argument_names = [:argument, :names]

      namespace :something do
        subject.define(
            argument_names: argument_names)
      end

      rake_task = Rake::Task["something:format"]

      expect(rake_task.arg_names).to(eq(argument_names))
    end
  end

  context 'pedantise task' do
    it 'configures with passed parameters' do
      profile = 'test'
      directory = 'module1'
      ensure_task_name = 'lein:ensure'

      namespace :lein do
        task :ensure
      end

      namespace :something do
        subject.define(
            profile: profile,
            directory: directory,
            ensure_task_name: ensure_task_name)
      end

      rake_task = Rake::Task["something:pedantise"]

      expect(rake_task.creator.profile).to(eq(profile))
      expect(rake_task.creator.directory).to(eq(directory))
      expect(rake_task.creator.ensure_task_name).to(eq(ensure_task_name))
    end

    it 'uses the provided pedantise task name when present' do
      namespace :something do
        subject.define(optimise_task_name: :bikeshed)
      end

      expect(Rake::Task.task_defined?("something:bikeshed")).to(be(true))
    end

    it 'uses the provided argument names when present' do
      argument_names = [:argument, :names]

      namespace :something do
        subject.define(
            argument_names: argument_names)
      end

      rake_task = Rake::Task["something:pedantise"]

      expect(rake_task.arg_names).to(eq(argument_names))
    end
  end

  context 'check task' do
    it 'defines the check command with the default task names' do
      namespace :something do
        subject.define
      end

      rake_task = Rake::Task["something:check"]

      expect(rake_task.creator.lint_task_name).to(eq(:lint))
      expect(rake_task.creator.optimise_task_name).to(eq(:optimise))
      expect(rake_task.creator.idiomise_task_name).to(eq(:idiomise))
      expect(rake_task.creator.format_task_name).to(eq(:format))
      expect(rake_task.creator.pedantise_task_name).to(eq(:pedantise))
    end

    it 'defines the check command with the specified task names' do
      namespace :lein do
        task :ensure
      end

      namespace :something do
        subject.define(
            lint_task_name: :eastwood,
            optimise_task_name: :check_reflection,
            idiomise_task_name: :kibit,
            format_task_name: :cljfmt,
            pedantise_task_name: :bikeshed)
      end

      rake_task = Rake::Task["something:check"]

      expect(rake_task.creator.lint_task_name).to(eq(:eastwood))
      expect(rake_task.creator.optimise_task_name).to(eq(:check_reflection))
      expect(rake_task.creator.idiomise_task_name).to(eq(:kibit))
      expect(rake_task.creator.format_task_name).to(eq(:cljfmt))
      expect(rake_task.creator.pedantise_task_name).to(eq(:bikeshed))
    end

    it 'uses the provided pedantise task name when present' do
      namespace :something do
        subject.define(check_task_name: :run_all_checks)
      end

      expect(Rake::Task.task_defined?("something:run_all_checks")).to(be(true))
    end
  end
end
