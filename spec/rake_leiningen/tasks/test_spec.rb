# frozen_string_literal: true

require 'spec_helper'

describe RakeLeiningen::Tasks::Test do
  include_context 'rake'

  before do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a test task in the namespace in which it is created' do
    namespace :something do
      described_class.define
    end

    expect(Rake.application)
      .to(have_task_defined('something:test'))
  end

  it 'gives the test task a description' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:test'].full_comment)
      .to(eq('Run all tests.'))
  end

  it 'uses the type in the task description when available' do
    namespace :something do
      described_class.define(type: 'unit')
    end

    expect(Rake::Task['something:test'].full_comment)
      .to(eq('Run all unit tests.'))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      described_class.define(name: :unit)
    end

    expect(Rake.application)
      .to(have_task_defined('something:unit'))
  end

  it 'allows multiple test tasks to be declared' do
    namespace :something1 do
      described_class.define
    end

    namespace :something2 do
      described_class.define
    end

    expect(Rake.application)
      .to(have_tasks_defined(
            %w[something1:test
               something2:test]
          ))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:test'].prerequisite_tasks)
      .to(include(Rake::Task['leiningen:ensure']))
  end

  it 'depends on the provided task if specified' do
    namespace :tools do
      namespace :leiningen do
        task :ensure
      end
    end

    namespace :something do
      described_class.define(ensure_task_name: 'tools:leiningen:ensure')
    end

    expect(Rake::Task['something:test'].prerequisite_tasks)
      .to(include(Rake::Task['tools:leiningen:ensure']))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = %i[deployment_identifier region]

    namespace :something do
      described_class.define(argument_names:)
    end

    expect(Rake::Task['something:test'].arg_names)
      .to(eq(argument_names))
  end

  it 'executes run on invocation' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:eftest))

    namespace :something do
      described_class.define
    end

    Rake::Task['something:test'].invoke

    expect(RubyLeiningen)
      .to(have_received(:eftest)
            .with(
              only: nil,
              test_selectors: nil,
              namespaces: nil,
              files: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided only when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:eftest))

    namespace :something do
      described_class.define(only: 'some.namespace/test-something')
    end

    Rake::Task['something:test'].invoke

    expect(RubyLeiningen)
      .to(have_received(:eftest)
            .with(
              only: 'some.namespace/test-something',
              test_selectors: nil,
              namespaces: nil,
              files: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided test selectors when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:eftest))

    namespace :something do
      described_class.define(test_selectors: %i[unit integration])
    end

    Rake::Task['something:test'].invoke

    expect(RubyLeiningen)
      .to(have_received(:eftest)
            .with(
              only: nil,
              test_selectors: %i[unit integration],
              namespaces: nil,
              files: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided namespaces when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:eftest))

    namespace :something do
      described_class.define(namespaces: %w[mylib.core mylib.helpers])
    end

    Rake::Task['something:test'].invoke

    expect(RubyLeiningen)
      .to(have_received(:eftest)
            .with(
              only: nil,
              test_selectors: nil,
              namespaces: %w[mylib.core mylib.helpers],
              files: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided files when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:eftest))

    namespace :something do
      described_class.define(
        files: %w[src/mylib/core.clj src/mylib/helpers.clj]
      )
    end

    Rake::Task['something:test'].invoke

    expect(RubyLeiningen)
      .to(have_received(:eftest)
            .with(
              only: nil,
              test_selectors: nil,
              namespaces: nil,
              files: %w[src/mylib/core.clj src/mylib/helpers.clj],
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided profile when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:eftest))

    namespace :something do
      described_class.define(profile: 'test')
    end

    Rake::Task['something:test'].invoke

    expect(RubyLeiningen)
      .to(have_received(:eftest)
            .with(
              only: nil,
              test_selectors: nil,
              namespaces: nil,
              files: nil,
              profile: 'test',
              environment: nil
            ))
  end

  it 'uses the provided environment when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:eftest))

    namespace :something do
      described_class.define(environment: { 'VAR' => 'val' })
    end

    Rake::Task['something:test'].invoke

    expect(RubyLeiningen)
      .to(have_received(:eftest)
            .with(
              only: nil,
              test_selectors: nil,
              namespaces: nil,
              files: nil,
              profile: nil,
              environment: { 'VAR' => 'val' }
            ))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'changes directory if the directory parameter is specified' do
    stub_output

    directory = 'some/other/directory'

    allow(Dir).to(receive(:chdir).and_yield)
    allow(RubyLeiningen).to(receive(:eftest))

    namespace :something do
      described_class.define(directory:)
    end

    Rake::Task['something:test'].invoke

    expect(Dir)
      .to(have_received(:chdir)
            .with(directory))
    expect(RubyLeiningen)
      .to(have_received(:eftest))
  end
  # rubocop:enable RSpec/MultipleExpectations

  def stub_chdir
    allow(Dir).to(receive(:chdir).and_yield)
  end

  def stub_output
    %i[print puts].each do |method|
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end
end
