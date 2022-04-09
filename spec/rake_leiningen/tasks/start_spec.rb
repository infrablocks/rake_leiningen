# frozen_string_literal: true

require 'spec_helper'

describe RakeLeiningen::Tasks::Start do
  include_context 'rake'

  before do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a start task in the namespace in which it is created' do
    namespace :something do
      described_class.define
    end

    expect(Rake.application)
      .to(have_task_defined('something:start'))
  end

  it 'gives the start task a description' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:start'].full_comment)
      .to(eq('Run the application.'))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      described_class.define(name: :run)
    end

    expect(Rake.application)
      .to(have_task_defined('something:run'))
  end

  it 'allows multiple build tasks to be declared' do
    namespace :something1 do
      described_class.define
    end

    namespace :something2 do
      described_class.define
    end

    expect(Rake.application)
      .to(have_tasks_defined(
            %w[something1:start
               something2:start]
          ))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:start'].prerequisite_tasks)
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

    expect(Rake::Task['something:start'].prerequisite_tasks)
      .to(include(Rake::Task['tools:leiningen:ensure']))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = %i[deployment_identifier region]

    namespace :something do
      described_class.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:start'].arg_names)
      .to(eq(argument_names))
  end

  it 'executes run on invocation' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:run))

    namespace :something do
      described_class.define
    end

    Rake::Task['something:start'].invoke

    expect(RubyLeiningen)
      .to(have_received(:run)
            .with(
              main_function: nil,
              arguments: nil,
              quote_arguments: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided main function when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:run))

    namespace :something do
      described_class.define(main_function: 'some.namespace/main')
    end

    Rake::Task['something:start'].invoke

    expect(RubyLeiningen)
      .to(have_received(:run)
            .with(
              main_function: 'some.namespace/main',
              arguments: nil,
              quote_arguments: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided arguments when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:run))

    namespace :something do
      described_class.define(arguments: %w[first second])
    end

    Rake::Task['something:start'].invoke

    expect(RubyLeiningen)
      .to(have_received(:run)
            .with(
              main_function: nil,
              arguments: %w[first second],
              quote_arguments: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided profile when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:run))

    namespace :something do
      described_class.define(profile: 'test')
    end

    Rake::Task['something:start'].invoke

    expect(RubyLeiningen)
      .to(have_received(:run)
            .with(
              main_function: nil,
              arguments: nil,
              quote_arguments: nil,
              profile: 'test',
              environment: nil
            ))
  end

  it 'uses the provided environment when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:run))

    namespace :something do
      described_class.define(environment: { 'VAR' => 'val' })
    end

    Rake::Task['something:start'].invoke

    expect(RubyLeiningen)
      .to(have_received(:run)
            .with(
              main_function: nil,
              arguments: nil,
              quote_arguments: nil,
              profile: nil,
              environment: { 'VAR' => 'val' }
            ))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'changes directory if the directory parameter is specified' do
    stub_output

    directory = 'some/other/directory'

    allow(Dir).to(receive(:chdir).and_yield)
    allow(RubyLeiningen).to(receive(:run))

    namespace :something do
      described_class.define(directory: directory)
    end

    Rake::Task['something:start'].invoke

    expect(Dir)
      .to(have_received(:chdir)
            .with(directory))
    expect(RubyLeiningen)
      .to(have_received(:run))
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
