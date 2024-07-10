# frozen_string_literal: true

require 'spec_helper'

describe RakeLeiningen::TaskSets::Checks do
  include_context 'rake'

  describe 'lint task' do
    it 'configures with passed profile' do
      profile = 'test'

      namespace :something do
        described_class.define(
          profile:
        )
      end

      rake_task = Rake::Task['something:lint']

      expect(rake_task.creator.profile).to(eq(profile))
    end

    it 'configures with passed environment' do
      environment = { 'VAR' => 'val' }

      namespace :something do
        described_class.define(
          environment:
        )
      end

      rake_task = Rake::Task['something:lint']

      expect(rake_task.creator.environment).to(eq(environment))
    end

    it 'configures with passed directory' do
      directory = 'module1'

      namespace :something do
        described_class.define(
          directory:
        )
      end

      rake_task = Rake::Task['something:lint']

      expect(rake_task.creator.directory).to(eq(directory))
    end

    it 'configures with passed ensure task name' do
      ensure_task_name = 'lein:ensure'

      namespace :lein do
        task :ensure
      end

      namespace :something do
        described_class.define(
          ensure_task_name:
        )
      end

      rake_task = Rake::Task['something:lint']

      expect(rake_task.creator.ensure_task_name).to(eq(ensure_task_name))
    end

    it 'uses the provided lint task name when present' do
      namespace :something do
        described_class.define(lint_task_name: :eastwood)
      end

      expect(Rake.application)
        .to(have_task_defined('something:eastwood'))
    end

    it 'uses the provided argument names when present' do
      argument_names = %i[argument names]

      namespace :something do
        described_class.define(
          argument_names:
        )
      end

      rake_task = Rake::Task['something:lint']

      expect(rake_task.arg_names).to(eq(argument_names))
    end
  end

  describe 'optimise task' do
    it 'configures with passed profile' do
      profile = 'test'

      namespace :something do
        described_class.define(
          profile:
        )
      end

      rake_task = Rake::Task['something:optimise']

      expect(rake_task.creator.profile).to(eq(profile))
    end

    it 'configures with passed environment' do
      environment = { 'VAR' => 'val' }

      namespace :something do
        described_class.define(
          environment:
        )
      end

      rake_task = Rake::Task['something:optimise']

      expect(rake_task.creator.environment).to(eq(environment))
    end

    it 'configures with passed directory' do
      directory = 'module1'

      namespace :something do
        described_class.define(
          directory:
        )
      end

      rake_task = Rake::Task['something:optimise']

      expect(rake_task.creator.directory).to(eq(directory))
    end

    it 'configures with passed ensure task name' do
      ensure_task_name = 'lein:ensure'

      namespace :lein do
        task :ensure
      end

      namespace :something do
        described_class.define(
          ensure_task_name:
        )
      end

      rake_task = Rake::Task['something:optimise']

      expect(rake_task.creator.ensure_task_name).to(eq(ensure_task_name))
    end

    it 'uses the provided optimise task name when present' do
      namespace :something do
        described_class.define(optimise_task_name: :check_reflection)
      end

      expect(Rake.application)
        .to(have_task_defined('something:check_reflection'))
    end

    it 'uses the provided argument names when present' do
      argument_names = %i[argument names]

      namespace :something do
        described_class.define(
          argument_names:
        )
      end

      rake_task = Rake::Task['something:optimise']

      expect(rake_task.arg_names).to(eq(argument_names))
    end
  end

  describe 'idiomise task' do
    it 'configures with passed profile' do
      profile = 'test'

      namespace :lein do
        task :ensure
      end

      namespace :something do
        described_class.define(
          profile:
        )
      end

      rake_task = Rake::Task['something:idiomise']

      expect(rake_task.creator.profile).to(eq(profile))
    end

    it 'configures with passed environment' do
      environment = { 'VAR' => 'val' }

      namespace :something do
        described_class.define(
          environment:
        )
      end

      rake_task = Rake::Task['something:idiomise']

      expect(rake_task.creator.environment).to(eq(environment))
    end

    it 'configures with passed directory' do
      directory = 'module1'

      namespace :something do
        described_class.define(
          directory:
        )
      end

      rake_task = Rake::Task['something:idiomise']

      expect(rake_task.creator.directory).to(eq(directory))
    end

    it 'configures with passed ensure task name' do
      ensure_task_name = 'lein:ensure'

      namespace :something do
        described_class.define(
          ensure_task_name:
        )
      end

      rake_task = Rake::Task['something:idiomise']

      expect(rake_task.creator.ensure_task_name).to(eq(ensure_task_name))
    end

    it 'uses a value of false for replace by default' do
      namespace :something do
        described_class.define
      end

      rake_task = Rake::Task['something:idiomise']

      expect(rake_task.creator.replace).to(be(false))
    end

    it 'sets replace to true when the fix parameter is true' do
      namespace :something do
        described_class.define(fix: true)
      end

      rake_task = Rake::Task['something:idiomise']

      expect(rake_task.creator.replace).to(be(true))
    end

    it 'sets replace to false when the fix parameter is false' do
      namespace :something do
        described_class.define(fix: false)
      end

      rake_task = Rake::Task['something:idiomise']

      expect(rake_task.creator.replace).to(be(false))
    end

    it 'uses the provided idiomise task name when present' do
      namespace :something do
        described_class.define(optimise_task_name: :kibit)
      end

      expect(Rake.application)
        .to(have_task_defined('something:kibit'))
    end

    it 'uses the provided argument names when present' do
      argument_names = %i[argument names]

      namespace :something do
        described_class.define(
          argument_names:
        )
      end

      rake_task = Rake::Task['something:idiomise']

      expect(rake_task.arg_names).to(eq(argument_names))
    end
  end

  describe 'format task' do
    it 'configures with passed profile' do
      profile = 'test'

      namespace :something do
        described_class.define(
          profile:
        )
      end

      rake_task = Rake::Task['something:format']

      expect(rake_task.creator.profile).to(eq(profile))
    end

    it 'configures with passed environment' do
      environment = { 'VAR' => 'val' }

      namespace :something do
        described_class.define(
          environment:
        )
      end

      rake_task = Rake::Task['something:format']

      expect(rake_task.creator.environment).to(eq(environment))
    end

    it 'configures with passed directory' do
      directory = 'module1'

      namespace :something do
        described_class.define(
          directory:
        )
      end

      rake_task = Rake::Task['something:format']

      expect(rake_task.creator.directory).to(eq(directory))
    end

    it 'configures with passed ensure task name' do
      ensure_task_name = 'lein:ensure'

      namespace :lein do
        task :ensure
      end

      namespace :something do
        described_class.define(
          ensure_task_name:
        )
      end

      rake_task = Rake::Task['something:format']

      expect(rake_task.creator.ensure_task_name).to(eq(ensure_task_name))
    end

    it 'sets mode to fix when the fix parameter is true' do
      namespace :something do
        described_class.define(fix: true)
      end

      rake_task = Rake::Task['something:format']

      expect(rake_task.creator.mode).to(eq(:fix))
    end

    it 'sets mode to check when the fix parameter is false' do
      namespace :something do
        described_class.define(fix: false)
      end

      rake_task = Rake::Task['something:format']

      expect(rake_task.creator.mode).to(eq(:check))
    end

    it 'uses the provided format task name when present' do
      namespace :something do
        described_class.define(optimise_task_name: :cljfmt)
      end

      expect(Rake.application)
        .to(have_task_defined('something:cljfmt'))
    end

    it 'uses the provided argument names when present' do
      argument_names = %i[argument names]

      namespace :something do
        described_class.define(
          argument_names:
        )
      end

      rake_task = Rake::Task['something:format']

      expect(rake_task.arg_names).to(eq(argument_names))
    end
  end

  describe 'pedantise task' do
    it 'configures with passed profile' do
      profile = 'test'

      namespace :something do
        described_class.define(
          profile:
        )
      end

      rake_task = Rake::Task['something:pedantise']

      expect(rake_task.creator.profile).to(eq(profile))
    end

    it 'configures with passed environment' do
      environment = { 'VAR' => 'val' }

      namespace :something do
        described_class.define(
          environment:
        )
      end

      rake_task = Rake::Task['something:pedantise']

      expect(rake_task.creator.environment).to(eq(environment))
    end

    it 'configures with passed directory' do
      directory = 'module1'

      namespace :something do
        described_class.define(
          directory:
        )
      end

      rake_task = Rake::Task['something:pedantise']

      expect(rake_task.creator.directory).to(eq(directory))
    end

    it 'configures with passed ensure task name' do
      ensure_task_name = 'lein:ensure'

      namespace :lein do
        task :ensure
      end

      namespace :something do
        described_class.define(
          ensure_task_name:
        )
      end

      rake_task = Rake::Task['something:pedantise']

      expect(rake_task.creator.ensure_task_name).to(eq(ensure_task_name))
    end

    it 'uses the provided pedantise task name when present' do
      namespace :something do
        described_class.define(optimise_task_name: :bikeshed)
      end

      expect(Rake.application)
        .to(have_task_defined('something:bikeshed'))
    end

    it 'uses the provided argument names when present' do
      argument_names = %i[argument names]

      namespace :something do
        described_class.define(
          argument_names:
        )
      end

      rake_task = Rake::Task['something:pedantise']

      expect(rake_task.arg_names).to(eq(argument_names))
    end
  end

  describe 'check task' do
    it 'defines the check command with the default lint task name' do
      namespace :something do
        described_class.define
      end

      rake_task = Rake::Task['something:check']

      expect(rake_task.creator.lint_task_name).to(eq(:lint))
    end

    it 'defines the check command with the default optimise task name' do
      namespace :something do
        described_class.define
      end

      rake_task = Rake::Task['something:check']

      expect(rake_task.creator.optimise_task_name).to(eq(:optimise))
    end

    it 'defines the check command with the default idiomise task name' do
      namespace :something do
        described_class.define
      end

      rake_task = Rake::Task['something:check']

      expect(rake_task.creator.idiomise_task_name).to(eq(:idiomise))
    end

    it 'defines the check command with the default format task name' do
      namespace :something do
        described_class.define
      end

      rake_task = Rake::Task['something:check']

      expect(rake_task.creator.format_task_name).to(eq(:format))
    end

    it 'defines the check command with the default pedantise task name' do
      namespace :something do
        described_class.define
      end

      rake_task = Rake::Task['something:check']

      expect(rake_task.creator.pedantise_task_name).to(eq(:pedantise))
    end

    it 'defines the check command with the specified line task name' do
      namespace :lein do
        task :ensure
      end

      namespace :something do
        described_class.define(
          lint_task_name: :eastwood
        )
      end

      rake_task = Rake::Task['something:check']

      expect(rake_task.creator.lint_task_name).to(eq(:eastwood))
    end

    it 'defines the check command with the specified optimise task names' do
      namespace :lein do
        task :ensure
      end

      namespace :something do
        described_class.define(
          optimise_task_name: :check_reflection
        )
      end

      rake_task = Rake::Task['something:check']

      expect(rake_task.creator.optimise_task_name).to(eq(:check_reflection))
    end

    it 'defines the check command with the specified idiomise task name' do
      namespace :lein do
        task :ensure
      end

      namespace :something do
        described_class.define(
          idiomise_task_name: :kibit
        )
      end

      rake_task = Rake::Task['something:check']

      expect(rake_task.creator.idiomise_task_name).to(eq(:kibit))
    end

    it 'defines the check command with the specified format task name' do
      namespace :lein do
        task :ensure
      end

      namespace :something do
        described_class.define(
          format_task_name: :cljfmt
        )
      end

      rake_task = Rake::Task['something:check']

      expect(rake_task.creator.format_task_name).to(eq(:cljfmt))
    end

    it 'defines the check command with the specified pedantise task name' do
      namespace :lein do
        task :ensure
      end

      namespace :something do
        described_class.define(
          pedantise_task_name: :bikeshed
        )
      end

      rake_task = Rake::Task['something:check']

      expect(rake_task.creator.pedantise_task_name).to(eq(:bikeshed))
    end

    it 'uses the provided check task name when present' do
      namespace :something do
        described_class.define(check_task_name: :run_all_checks)
      end

      expect(Rake.application)
        .to(have_task_defined('something:run_all_checks'))
    end
  end
end
