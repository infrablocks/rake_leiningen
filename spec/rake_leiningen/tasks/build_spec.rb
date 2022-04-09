# frozen_string_literal: true

require 'spec_helper'

describe RakeLeiningen::Tasks::Build do
  include_context 'rake'

  before do
    namespace :leiningen do
      task :ensure
    end
  end

  it 'adds a build task in the namespace in which it is created' do
    namespace :something do
      described_class.define
    end

    expect(Rake.application)
      .to(have_task_defined('something:build'))
  end

  it 'gives the build task a description' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:build'].full_comment)
      .to(eq('Build standalone uberjar.'))
  end

  it 'allows the task name to be overridden' do
    namespace :something do
      described_class.define(name: :jar)
    end

    expect(Rake.application)
      .to(have_task_defined('something:jar'))
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
            %w[something1:build
               something2:build]
          ))
  end

  it 'depends on the leiningen:ensure task by default' do
    namespace :something do
      described_class.define
    end

    expect(Rake::Task['something:build'].prerequisite_tasks)
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

    expect(Rake::Task['something:build'].prerequisite_tasks)
      .to(include(Rake::Task['tools:leiningen:ensure']))
  end

  it 'configures the task with the provided arguments if specified' do
    argument_names = %i[deployment_identifier region]

    namespace :something do
      described_class.define(argument_names: argument_names)
    end

    expect(Rake::Task['something:build'].arg_names)
      .to(eq(argument_names))
  end

  it 'executes uberjar on invocation' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:uberjar))

    namespace :something do
      described_class.define
    end

    Rake::Task['something:build'].invoke

    expect(RubyLeiningen)
      .to(have_received(:uberjar)
            .with(
              main_namespace: nil,
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided main namespace when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:uberjar))

    namespace :something do
      described_class.define(main_namespace: 'some.namespace')
    end

    Rake::Task['something:build'].invoke

    expect(RubyLeiningen)
      .to(have_received(:uberjar)
            .with(
              main_namespace: 'some.namespace',
              profile: nil,
              environment: nil
            ))
  end

  it 'uses the provided profile when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:uberjar))

    namespace :something do
      described_class.define(profile: 'test')
    end

    Rake::Task['something:build'].invoke

    expect(RubyLeiningen)
      .to(have_received(:uberjar)
            .with(
              main_namespace: nil,
              profile: 'test',
              environment: nil
            ))
  end

  it 'uses the provided environment when specified' do
    stub_output
    stub_chdir

    allow(RubyLeiningen).to(receive(:uberjar))

    namespace :something do
      described_class.define(environment: { 'VAR' => 'val' })
    end

    Rake::Task['something:build'].invoke

    expect(RubyLeiningen)
      .to(have_received(:uberjar)
            .with(
              main_namespace: nil,
              profile: nil,
              environment: { 'VAR' => 'val' }
            ))
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'changes directory if the directory parameter is specified' do
    stub_output

    directory = 'some/other/directory'

    allow(Dir).to(receive(:chdir).and_yield)
    allow(RubyLeiningen).to(receive(:uberjar))

    namespace :something do
      described_class.define(directory: directory)
    end

    Rake::Task['something:build'].invoke

    expect(Dir)
      .to(have_received(:chdir)
            .with(directory))
    expect(RubyLeiningen)
      .to(have_received(:uberjar))
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
